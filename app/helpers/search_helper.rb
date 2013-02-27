module SearchHelper
	def search_query_status_select(builder)
		builder.select :status , search_query_status_options
	end

	def search_query_status_options
		options_for_select(SearchQuery::MAPPED_STATUSES)
	end
end
