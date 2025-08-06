class OrderMailer < ApplicationMailer
    default from: 'no-reply@example.com'

    def thank(order)
        @order = order
        recipient = order.user&.email || order.gemail
        mail(to: recipient, subject: 'Thank you')
    end

end
