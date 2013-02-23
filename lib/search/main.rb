module Search
	GOOGLE_URL = 'http://google.com'
	SEARCH_RESULT_ROW_CSS = 'li.g'
	PAGINATE_LINK_CSS = 'fl'

	class Main		
		attr_accessor :search_string

		def initialize(search_order = nil)			
			if search_order.instance_of? SearchOrder
				@search_order = search_order
				@total_results_count = @search_order.total_results
				@search_string = Search::SearchString.new(search_order).to_s
			end
		end

		def search						
			search_result_page = submit_search_form_with(@search_string)
			nokogiri_elements = to_array_of_nokogiri_elements(search_result_page)			
			search_results = to_array_of_hashes(nokogiri_elements)			
		end

		def submit_search_form_with(search_string)
			agent =  Mechanize.new		
			agent.get GOOGLE_URL
			search_form = agent.page.form_with(:name => 'f')
			search_form.q = search_string			
			search_form.submit
		end

		def to_array_of_hashes(nokogiri_elements)
			nokogiri_elements ||= []
			nokogiri_elements.map do |element|
				a = element.at_css('a')					
				{					
					:text  			 => a.children.map(&:text).join,
					:href  			 => a.attributes['href'].value,
					:description => element.at_css('.s').text,
				}
			end			
		end

		def to_array_of_nokogiri_elements(search_result_page)
			results = []
			page = 1
			while( ( remaining_results_count = @total_results_count - results.size ) > 0) do
				next_page_index = page - 1
				results = results + search_result_page.search(SEARCH_RESULT_ROW_CSS)[0...remaining_results_count]
				next_page_link = search_result_page.links_with(:class => PAGINATE_LINK_CSS)[next_page_index]

				break unless next_page_link.present?

				next_page_link.click
				page = page + 1
			end
			results
			
		end
	end
end