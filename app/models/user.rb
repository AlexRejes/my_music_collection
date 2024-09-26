class User < ApplicationRecord
  # Inclui os módulos do Devise
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Validações
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true

  # Verifica se o usuário é administrador
  def admin?
    role == "admin"
  end

  # Substitui a busca por email por username
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (username = conditions.delete(:username))
      where(conditions).where([ "lower(username) = :value", { value: username.downcase } ]).first
    else
      where(conditions).first
    end
  end
end
