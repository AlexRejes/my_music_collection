class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  # Permite parâmetros personalizados para login e cadastro
  def configure_permitted_parameters
    # Permitir o uso do username e email no login
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :username, :email ])

    # Permitir os campos full_name, username, email, role, password e password_confirmation durante o registro
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :full_name, :username, :email, :role, :password, :password_confirmation ])

    # Permitir os campos full_name, username, email, role, password e password_confirmation na edição do perfil
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :username, :email, :role, :password, :password_confirmation ])
  end

  # Redireciona o usuário para a página de login após o registro
  def after_sign_up_path_for(resource)
    new_user_session_path # Vai para a página de login após o cadastro
  end

  # Redireciona o usuário para a página de álbuns após o login
  def after_sign_in_path_for(resource)
    albums_path
  end

  # Redireciona para a página de login após o logout
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
