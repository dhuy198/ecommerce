# frozen_string_literal: true

class User::PasswordsController < Devise::PasswordsController
  before_action :set_hide_navbar, only: [ :new, :create, :edit, :update ]

  # GET /resource/password/new
  def new
    super
    Rails.logger.info "PasswordsController#new called, @hide = #{@hide}"
  end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
    Rails.logger.info "PasswordsController#edit called, @hide = #{@hide}"
  end

  # PUT /resource/password
  # def update
  #   super
  # end

  private

  def set_hide_navbar
    @hide = true
    Rails.logger.info "set_hide_navbar called, @hide = #{@hide}"
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
