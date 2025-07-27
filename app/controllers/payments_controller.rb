class PaymentsController < ApplicationController
    def create
        cart = Cart.find(payments_params[:cart_id])
        line_items = cart.cart_items.map do |item|
            {
            price_data: {
                currency: 'usd',
                unit_amount: (item.product.price * 100).to_i, # Stripe dùng cent
                product_data: {
                name: item.product.name
                }
            },
            quantity: item.quantity
            }
        end
        success_url = url_for(controller: 'payments', action: 'success', only_path: false, booking_params: payments_params.except(:stripeToken))
        session = Stripe::Checkout::Session.create({
            payment_method_types: ['card'],
            line_items: line_items,
            mode: 'payment',
            customer: stripe_customer.id,
            success_url: success_url,

            # cancel_url: 
        })
        redirect_to session.url, allow_other_host: true, status:303
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
        if cart.cart_items.empty?
            return render json: { error: "Empty order" }, status: :unprocessable_entity
        end

        order = current_user.orders.create!(
            total: 0,
            status: "paid"
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
        end

        order.update!(total: total)
        cart.cart_items.destroy_all

    end

    private 
    def payments_params 
        params.permit(
            :stripeToken,
            :cart_id,
            :user_id,
            :total
        )
    end
end