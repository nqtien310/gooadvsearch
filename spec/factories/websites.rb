# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	sequence :domain_name do |n|
		"http://www.domain#{n}.com"		
	end
	
  factory :website do
    domain_name
  end
end
