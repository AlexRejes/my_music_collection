class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  # Permite parâmetros personalizados para login e cadastro
  def configure_permitted_parameters
    # Permitir o uso do username no login
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :username ])

    # Permitir os campos full_name, username e role durante o registro
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :full_name, :username, :role ])

    # Permitir os campos full_name, username e role na edição do perfil
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :username, :role ])
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
