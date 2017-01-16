FactoryGirl.define do
  factory :users_training do
    association :user, factory: :user
    association :training, factory: :training
  end
end
