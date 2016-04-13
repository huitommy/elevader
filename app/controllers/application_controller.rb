class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :avatar, :avatar_cache)
    end

    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:login, :username, :email, :password)
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :current_password, :avatar, :avatar_cache)
    end
  end
end
