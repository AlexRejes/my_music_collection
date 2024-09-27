class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true

  def admin?
    role == "admin"
  end


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (username = conditions.delete(:username))
      where(conditions).where([ "lower(username) = :value", { value: username.downcase } ]).first
    else
      where(conditions).first
    end
  end
end
