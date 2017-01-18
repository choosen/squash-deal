# assignment between users and trainings
class UsersTraining < ApplicationRecord
  self.primary_keys = :user_id, :training_id
  belongs_to :user, counter_cache: :trainings_count
  belongs_to :training

  validates :training, presence: true
  validates :user, presence: true
  validate :created_before_training_date, on: :create
  validate :accepted_at_not_changed
  validate :accepted_at_before_training

  def accepted?
    accepted_at.present?
  end

  private

  def accepted_at_not_changed
    return if accepted_at_was.nil?
    errors.add(:accepted_at, 'User can accept invitition only once')
  end

  def accepted_at_before_training
    return if accepted_at.nil? || training.date + 1.hour >= accepted_at
    errors.add(:accepted_at, 'User can accept invitition before training')
  end

  def created_before_training_date
    return if training.nil? || training.date >= DateTime.current
    errors.add(:accepted_at, 'You can only invite players for future trainings')
  end
end
