class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :username, :email ])


    devise_parameter_sanitizer.permit(:sign_up, keys: [ :full_name, :username, :email, :role, :password, :password_confirmation ])


    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :username, :email, :role, :password, :password_confirmation ])
  end


  def after_sign_up_path_for(resource)
    new_user_session_path
  end


  def after_sign_in_path_for(resource)
    albums_path
  end


  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
