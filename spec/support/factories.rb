FactoryGirl.define do

  factory :subscription do
    sequence(:query) { |i| "query #{i}"}
  end

end