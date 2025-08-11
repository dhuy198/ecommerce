class PaymentsController < ApplicationController
  before_action :set_hide_navbar

  def create
    stock_errors = []
    cart = Cart.find(payments_params[:cart_id])
    cart.cart_items.each do |item|
      if item.product.stock < item.quantity
        stock_errors << "Sản phẩm '#{item.product.name}' chỉ còn #{item.product.stock} trong kho."
      end
    end
    if stock_errors.any?
      flash[:alert] = stock_errors.join("\n")
      return redirect_to cart_path
    end

    if payments_params[:payment_method_id].present?
      begin
        payment_method = Stripe::PaymentMethod.retrieve(payments_params[:payment_method_id])

        p payment_method
        p stripe_customer
        p "-------------------------------"

        # Nếu payment_method.customer khác customer hiện tại hoặc nil thì attach
        if payment_method.customer != stripe_customer.id
          begin
            # Stripe::PaymentMethod.attach(
            #   payments_params[:payment_method_id],
            #   { customer: stripe_customer.id }
            # )

            payment_intent = Stripe::PaymentIntent.create({
              amount: total_amount,
              currency: 'usd',
              customer: stripe_customer.id,
              payment_method: params[:payment_method_id],
              off_session: true,
              confirm: true,
              setup_future_usage: 'off_session',  # Quan trọng để lưu thẻ
            })
          rescue Stripe::InvalidRequestError => e
            # Xóa thẻ lỗi khỏi DB, thông báo cho user
            Card.find_by(stripe_card_id: payments_params[:payment_method_id])&.destroy
            flash[:alert] = "Thẻ này không thể sử dụng lại. Vui lòng thêm thẻ mới."
            return redirect_to cart_path
          end
        end

        total_amount = (cart.cart_items.sum { |item| item.product.price * item.quantity } * 100).to_i

        payment_intent = Stripe::PaymentIntent.create({
          amount: total_amount,
          currency: 'usd',
          customer: stripe_customer.id,
          payment_method: payments_params[:payment_method_id],
          off_session: true,
          confirm: true,
        })

        redirect_to payments_success_path(payment_intent_id: payment_intent.id)
      rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to cart_path
      rescue Stripe::InvalidRequestError => e
        # Trường hợp payment_method đã bị detach hoặc không hợp lệ
        # Card.find_by(stripe_card_id: payments_params[:payment_method_id])&.destroy
        flash[:alert] = "Thẻ này không thể sử dụng lại. Vui lòng thêm thẻ mới. 11111111111111111111111"
        redirect_to cart_path
      end
    else
      line_items = cart.cart_items.map do |item|
        {
          price_data: {
            currency: 'usd',
            unit_amount: (item.product.price * 100).to_i,
            product_data: {
              name: item.product.name
            }
          },
          quantity: item.quantity
        }
      end

      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: line_items,
        mode: 'payment',
        customer: stripe_customer.id,
        success_url: "#{root_url}payments/success?session_id={CHECKOUT_SESSION_ID}",
        payment_intent_data: {
          setup_future_usage: 'off_session'   # <-- quan trọng đây
        },
      })
      redirect_to session.url, allow_other_host: true, status: 303
    end
  end

  def success_payment_intent
  payment_intent_id = params[:payment_intent_id]
  payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)
  payment_method = Stripe::PaymentMethod.retrieve(payment_intent.payment_method)

  if payment_method.customer != stripe_customer.id
    begin
      Stripe::PaymentMethod.attach(
        payment_method.id,
        { customer: stripe_customer.id }
      )
    rescue Stripe::InvalidRequestError => e
      flash[:alert] = "Không thể lưu thẻ này. Vui lòng thử lại với thẻ khác."
      return redirect_to cart_path
    end
  end

  Card.find_or_create_by!(
    user_id: current_user.id,
    stripe_card_id: payment_method.id
  ) do |card|
    card.brand = payment_method.card.brand
    card.last4 = payment_method.card.last4
    card.exp_month = payment_method.card.exp_month
    card.exp_year = payment_method.card.exp_year
  end

    cart = current_user.cart

    order = current_user.orders.create!(
      total: 0,
      payment_status: "paid",
      deliverd_status: "pending",
      payment_method: "card",
      shipping_address: current_user.address,
    )

    total = 0
    cart.cart_items.includes(:product).each do |item|
      price = item.product.price
      quantity = item.quantity
      total += price * quantity

      order.order_items.create!(
        product: item.product,
        price: price,
        quantity: quantity
      )
      item.product.update(stock: item.product.stock - item.quantity)
    end

    OrderMailer.thank(order).deliver_later
    order.update!(total: total)
    cart.cart_items.destroy_all

    redirect_to order_path(order), notice: "Payment successful!"
  end

  def stripe_customer
    @stripe_customer ||= begin
      if current_user.stripe_customer_id.nil?
        customer = Stripe::Customer.create({
          name: current_user.name,
          email: current_user.email,
        })
        current_user.update(stripe_customer_id: customer.id)
        customer
      else
        Stripe::Customer.retrieve(current_user.stripe_customer_id)
      end
    end
  end

  def success
    cart = current_user.cart
    session_id = params[:session_id]
    checkout_session = if params[:session_id].present?
                         Stripe::Checkout::Session.retrieve(session_id).payment_intent
                       else
                         params[:payment_intent_id]
                       end

    payment_intent = Stripe::PaymentIntent.retrieve(checkout_session)

    payment_method = Stripe::PaymentMethod.retrieve(payment_intent.payment_method)

    Card.find_or_create_by!(
      user_id: current_user.id,
      stripe_card_id: payment_method.id
    ) do |card|
      card.brand = payment_method.card.brand
      card.last4 = payment_method.card.last4
      card.exp_month = payment_method.card.exp_month
      card.exp_year = payment_method.card.exp_year
    end

    order = current_user.orders.create!(
      total: 0,
      payment_status: "paid",
      deliverd_status: "pending",
      payment_method: "cart",
      shipping_address: current_user.address,
    )

    total = 0
    cart.cart_items.includes(:product).each do |item|
      price = item.product.price
      quantity = item.quantity
      total += price * quantity

      order.order_items.create!(
        product: item.product,
        price: price,
        quantity: quantity
      )
      item.product.update(stock: item.product.stock - item.quantity)
    end

    OrderMailer.thank(order).deliver_later
    order.update!(total: total)
    cart.cart_items.destroy_all
  end

  private
  def payments_params
    params.permit(
      :stripeToken,
      :cart_id,
      :user_id,
      :total,
      :payment_method_id
    )
  end

  def set_hide_navbar
    @hide = true
  end
end
