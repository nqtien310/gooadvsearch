class SearchController < ApplicationController
	def index
		@search_order = SearchOrder.new
		@search_order.search_queries.build
		@search_order.websites.build
	end

	def create
		@search_order = SearchOrder.new(params['search_order'])

		if(@search_order.save)
			search_engine = Search::Main.new(@search_order)
			@search_results = search_engine.search
			@search_order.finish!
		end
		
		render :index
	end
end