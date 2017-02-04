# frozen_string_literal: true
# Model for logging trainer and player
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :trainings, through: :users_trainings
  has_many :users_trainings, dependent: :destroy

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
