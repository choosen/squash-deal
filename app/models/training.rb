# Training info
class Training < ApplicationRecord
  has_many :users, through: :users_trainings
  has_many :users_trainings, dependent: :destroy
  belongs_to :owner, class_name: 'User'

  validates :date, presence: true
  validates :owner, presence: true
  validates :price, allow_nil: true, numericality: { greater_than: 0.0 }
  validate :date_cannot_be_change_to_the_past
  validate :finished_cannot_be_changed, on: :update

  scope :date_between,
        ->(start, end_d) { where('date >= ? AND date <= ?', start, end_d) }

  def done?
    date < DateTime.current
  end

  def price_per_user
    number_of_present = UsersTraining.where(training_id: id,
                                            attended: true).count
    return 0 if number_of_present.zero?
    price / number_of_present
  end

  def date_cannot_be_change_to_the_past
    return if date.nil? || !date_changed? || date.future?
    errors.add(:date, 'Training date must be in the future')
  end

  def finished_cannot_be_changed
    return if !persisted? || !finished_was
    errors.add(:base, 'Training cannot be changed after finishing')
  end
end
