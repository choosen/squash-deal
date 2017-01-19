FactoryGirl.define do
  factory :training do
    date DateTime.current + 2.days
    price '120.00'
  end
end
