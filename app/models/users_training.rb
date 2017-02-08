# assignment between users and trainings
class UsersTraining < ApplicationRecord
  before_create :set_multisport_used
  self.primary_keys = :user_id, :training_id
  belongs_to :user, counter_cache: :trainings_count
  belongs_to :training

  validates :training, presence: true
  validates :user, presence: true
  validate :cannot_create_before_training_date, on: :create
  validate :primary_keys_not_changed, on: :update
  validate :accepted_at_not_changed
  validate :accepted_at_before_training
  validate :cannot_change_finished_training, on: :update

  def accepted?
    accepted_at.present?
  end

  def user_price
    return 0 unless attended?
    return training.price_per_user unless multisport_used?
    training.price_per_user - 15
  end

  private

  def accepted_at_not_changed
    return if accepted_at_was.nil? || accepted_at_was == accepted_at
    errors.add(:accepted_at, 'User can accept invitition only once')
  end

  def accepted_at_before_training
    return if accepted_at.nil? || training.date + 1.hour >= accepted_at
    errors.add(:accepted_at, 'User can accept invitition before training')
  end

  def cannot_create_before_training_date
    return if training.nil? || training.date.future?
    errors.add(:base, 'You can only invite players for future trainings')
  end

  def cannot_change_finished_training
    return if training.nil? || !training.finished?
    errors.add(:base, 'You cannot changed already finished trainings')
  end

  def set_multisport_used
    self.multisport_used = user.multisport
  end

  def primary_keys_not_changed
    return unless persisted?
    errors.add(:user, 'Change of user is not allowed') if user_id_changed?
    return unless training_id_changed?
    errors.add(:training, 'Change of training is not allowed')
  end
end
