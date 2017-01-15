# assignment between users and trainings
class UsersTraining < ApplicationRecord
  belongs_to :user
  belongs_to :training
end
