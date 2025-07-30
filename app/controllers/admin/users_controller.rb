class Admin::UsersController < Admin::ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role, :address, :city, :state, :country)
  end
end
