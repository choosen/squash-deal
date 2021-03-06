# frozen_string_literal: true
# Model for logging trainer and player
class User < ApplicationRecord
  before_save :set_name_if_blank

  devise :invitable, :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :trainings, through: :users_trainings
  has_many :owned_trainings, class_name: 'Training', foreign_key: 'owner_id',
                             dependent: :nullify
  has_many :users_trainings, dependent: :destroy

  scope :not_invited_to_training, lambda { |training|
    User.where('NOT EXISTS (SELECT 1 FROM "users_trainings" WHERE ' \
    '("users"."id" = "users_trainings"."user_id" and ' \
    '"users_trainings"."training_id" = ?) LIMIT 1)', training.id)
  }

  def set_name_if_blank
    self.name = email.split('@').first.titleize if name.blank?
  end

  def display_name
    name || email
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data['email'])
    user || User.create_without_invite(name: data['name'],
                                       email: data['email'],
                                       password: Devise.friendly_token[0, 20])
  end

  def self.create_without_invite(params)
    user = User.invite!(params) { |u| u.skip_invitation = true }
    user.accept_invitation!
    user
  end
end
