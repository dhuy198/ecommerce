class OrderMailer < ApplicationMailer
    default from: 'no-reply@example.com'

    def thank(order)
        @order = order
        @user = order.user
        mail(to: @user.email, subject: 'Thank you') 
    end
end
