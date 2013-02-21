# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :website do
    search_order 1
    domain_name "MyString"
  end
end
