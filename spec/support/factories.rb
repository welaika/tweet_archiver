FactoryGirl.define do

  factory :subscription do
    sequence(:query) { |i| "query #{i}"}
  end

  factory :tweet do
    sequence(:text) { |i| "tweet #{i}"}
  end

end