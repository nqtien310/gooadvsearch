# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :search_query do
		content "search string"    

		factory :exact_search_query do
			status SearchQuery::STATUSES[:EXACT]
		end

		factory :excluded_search_query do
			status SearchQuery::STATUSES[:EXCLUDED]
		end

		factory :and_search_query do
			status SearchQuery::STATUSES[:AND]
		end

		factory :or_search_query do
			status SearchQuery::STATUSES[:OR]
		end

		factory :synonym_search_query do
			status SearchQuery::STATUSES[:SYNONYM]
		end
	end
end