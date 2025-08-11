class Admin::PagesController < Admin::ApplicationController
    before_action :authenticate_admin!
    def index
        @orders = Order.all
        @revenue_by_month = Order.group_by_month(:created_at, last: 7).sum(:total)
        @orders_by_day = Order.group_by_day(:created_at, last: 7).count
        
    end
end