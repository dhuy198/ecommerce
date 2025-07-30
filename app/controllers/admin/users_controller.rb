class Admin::UsersController < Admin::ApplicationController
    before_action :authenticate_admin!
    def index
    end
end
