# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  before_action :set_hide_navbar, only: [ :new, :create ]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  private

  def set_hide_navbar
    @hide = true
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  # The path used after sign in.
  def after_sign_in_path_for(resource)
    # Redirect to home page after successful login
    root_path
  end

  # The path used after sign out.
  def after_sign_out_path_for(resource_or_scope)
    # Redirect to home page after logout
    root_path
  end
end
