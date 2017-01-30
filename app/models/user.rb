# frozen_string_literal: true
# Model for logging trainer and player
class User < ApplicationRecord
  before_save :set_name_if_blank

  devise :invitable, :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable, :trackable, :validatable
  has_many :trainings, through: :users_trainings
  has_many :users_trainings, dependent: :destroy

  def set_name_if_blank
    self.name = email.split('@').first if name.blank?
  end

  def display_name
    name || email
  end
end
