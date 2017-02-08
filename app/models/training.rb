# Training info
class Training < ApplicationRecord
  after_create :assign_owner_to_training
  has_many :users, through: :users_trainings
  has_many :users_trainings, dependent: :destroy
  belongs_to :owner, class_name: 'User'

  validates :date, presence: true
  validates :owner, presence: true
  validates :price, allow_nil: true, numericality: { greater_than: 0.0 }
  validate :date_cannot_be_change_to_the_past
  validate :finished_cannot_be_changed, on: :update
  validate :cannot_finish_until_done

  scope :date_between,
        ->(start, end_d) { where('date >= ? AND date <= ?', start, end_d) }

  def done?
    (date + 1.hour).past?
  end

  def price_per_user
    number_of_present = UsersTraining.where(training_id: id,
                                            attended: true).count
    return 0 if number_of_present.zero?
    price / number_of_present
  end

  private

  def date_cannot_be_change_to_the_past
    return if date.nil? || !date_changed? || date.future?
    errors.add(:date, 'Training date must be in the future')
  end

  def finished_cannot_be_changed
    return unless persisted?
    return unless finished_was
    errors.add(:base, 'Training cannot be changed after finishing')
  end

  def cannot_finish_until_done
    return if date.nil?
    return if done?
    return unless finished
    errors.add(:finished, 'Can not finish training until it is done')
  end

  def assign_owner_to_training
    UsersTraining.create(user: owner, training_id: id,
                         accepted_at: DateTime.current)
  end
end
