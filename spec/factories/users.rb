# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "tester#{n}@wp.pl" }
    password 'password123'

    trait :admin do
      email 'admin@example.com'
      admin true
    end

    factory :admin, traits: [:admin]
  end
end
