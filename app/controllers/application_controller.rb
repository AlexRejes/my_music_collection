class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  # Redireciona o usuário para a página de login após o registro
  def after_sign_up_path_for(resource)
    new_user_session_path # Vai para a página de login após o cadastro
  end

  # Redireciona o usuário para a página de álbuns após o login
  def after_sign_in_path_for(resource)
    albums_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # Redireciona para a página de login após o logout
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :full_name, :username, :role ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :username, :role ])
  end
end
