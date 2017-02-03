FactoryGirl.define do
  factory :users_training do
    user
    association :training, factory: :training

    after(:build) do |users_training|
      users_training.training.owner = users_training.user
      users_training.training.save
    end
  end
end
