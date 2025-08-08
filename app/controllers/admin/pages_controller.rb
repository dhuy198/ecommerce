class Admin::PagesController < Admin::ApplicationController
    before_action :authenticate_admin!
    def index

    end
end