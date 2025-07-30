class Admin::OrdersController < Admin::ApplicationController
    before_action :authenticate_admin!
    def index
    end
end
