# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search_query do
    search_order_id 1
    content "MyString"
    status "exact"
  end
end
