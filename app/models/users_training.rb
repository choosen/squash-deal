# assignment between users and trainings
class UsersTraining < ApplicationRecord
  self.primary_keys = :user_id, :training_id
  belongs_to :user, counter_cache: :trainings_count
  belongs_to :training
  validate :accepted_at_not_changed

  private

  def accepted_at_not_changed
    return if accepted_at_was.nil?
    errors.add(:accepted_at, 'User can accept invitition only once') # to check
  end
end
