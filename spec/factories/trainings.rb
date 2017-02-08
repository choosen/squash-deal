FactoryGirl.define do
  factory :training do
    date DateTime.current + 2.days
    price '120.00'
    association :owner, factory: :user

    trait :from_yesterday do
      date DateTime.current.yesterday
    end
  end

  factory :training_with_users, parent: :training do
    transient do
      users_count 2
    end

    after(:create) do |training, evaluator|
      (0...evaluator.users_count).each do
        training.users << create(:user)
      end
    end
  end
end
