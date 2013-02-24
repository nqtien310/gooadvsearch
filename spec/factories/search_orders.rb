# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search_order do
    total_results 10
    status "pending"
    search_type "image"
  end
end
