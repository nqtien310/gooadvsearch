# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search_order do
    total_results 1
    status "MyString"
    search_type "MyString"
  end
end
