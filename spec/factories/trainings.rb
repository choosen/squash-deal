FactoryGirl.define do
  factory :training do
    date DateTime.current + 2.days
    price '120.00'

    factory :training_with_user do
      ignore do
        user { create(:user) }
      end

      after(:create) do |training, evaluator|
        training.users << evaluator.user
      end
    end

    factory :training_with_users do
      ignore do
        users_count 3
      end

      after(:create) do |training, evaluator|
        (0...evaluator.users_count).each do
          training.users << create(:user)
        end
      end
    end
  end
end
