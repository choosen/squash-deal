# Training info
class Training < ApplicationRecord
  has_many :users, through: :users_trainings
  has_many :users_trainings
  alias_attribute :start, :date
end