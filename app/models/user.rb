# frozen_string_literal: true
# Model for logging trainer and player
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :trainings, through: :users_trainings
  has_many :users_trainings
end
