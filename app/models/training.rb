# Training info
class Training < ApplicationRecord
  has_many :users, through: :users_trainings
  has_many :users_trainings, dependent: :destroy

  validates :date, presence: true

  scope :date_between,
        ->(start, end_d) { where('date >= ? AND date <= ?', start, end_d) }
end
