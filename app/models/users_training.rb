# assignment between users and trainings
class UsersTraining < ApplicationRecord
  belongs_to :user, counter_cache: :trainings_count
  belongs_to :training
end
