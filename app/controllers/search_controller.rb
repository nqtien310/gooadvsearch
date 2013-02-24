class SearchController < ApplicationController
	def index
		@search_order = SearchOrder.new
	end

	def create
		@search_order = SearchOrder.new(params['search_order'])

		if(@search_order.save)
			search_engine = Search::Main.new(@search_order)
			@search_results = search_engine.search
		end

		render :index
	end
end