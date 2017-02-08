FactoryGirl.define do
  factory :users_training do
    user
    training
    attended false

    trait :attended do
      attended true
    end

    after(:build) do |users_training|
      users_training.training.owner = users_training.user
      users_training.training.save
    end
  end
end
