# frozen_string_literal: true
# Model for logging trainer and player
class User < ApplicationRecord
  before_save :set_name_if_blank

  devise :invitable, :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :trainings, through: :users_trainings
  has_many :users_trainings, dependent: :destroy

  def set_name_if_blank
    self.name = email.split('@').first if name.blank?
  end

  def display_name
    name || email
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data['email'])

    # users to be created if they don't exist
    unless user
      user = User.create(name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0, 20])
    end
    user
  end
end
