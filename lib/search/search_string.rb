module Search
	class SearchString
		def initialize(search_order)
			@search_order = search_order
		end

		def to_s			
			"#{string_from_search_queries} #{string_from_domain_names}"
		end

		def string_from_search_queries
			@search_order.search_queries.collect do |query|
				content = query.content.delete('"')

				case query.status
					when SearchQuery::STATUSES[:EXACT]
						"\"#{content}\""	
					when SearchQuery::STATUSES[:EXCLUDED]
						content.split(' ').collect { |word| "-#{word}"}.join(' ')
					when SearchQuery::STATUSES[:OR]						
						content.split(' ').collect { |word|	word.gsub(/^-/, '') }.reject{ |word| word.strip.length == 0 }.join(' OR ')						
					when SearchQuery::STATUSES[:SYNONYM]						
						content.split(' ').collect { |word|	"~#{word}" }.join(' ')
					when SearchQuery::STATUSES[:ALLINURL]						
						"allinurl:#{content}"						
					when SearchQuery::STATUSES[:ALLINTITLE]						
						"allintitle:#{content}"
					when SearchQuery::STATUSES[:AND]
						content			
					end
			end.join(' ')
		end

		def string_from_domain_names
			@search_order.websites.map(&:domain_name).collect do |domain_name|
				"site:#{domain_name}"
			end.join(' OR ')
		end
	end
end