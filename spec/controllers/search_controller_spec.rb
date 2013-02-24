require 'spec_helper'

describe SearchController do
	describe 'GET#index' do
		before(:each) { get :index }

		it 'should be success' do
			response.should be_success
		end

		it 'should render template index' do
			response.should render_template('index')
		end
	end

	describe 'POST#create' do
		context 'invalid search_order' do
			context 'without search_query' do
				before(:each) do										
					post :create , :search_order => FactoryGirl.attributes_for(:search_order)
				end
				
				it 'should be success' do
					response.should be_success
				end

				it 'should render template index' do
					response.should render_template('index')
				end

				it 'should return error messages on base' do
					search_order = assigns(:search_order)
					search_order.errors[:base].should == ['At least 1 search query must be presented']
				end
			end

			context 'with search_query' do
				context 'empty search string' do
					let(:search_string) { '  ' }
					let(:search_queries_attributes) { [ FactoryGirl.attributes_for(:exact_search_query, :content => search_string) ] }

					before(:each) do						
						post :create , :search_order => FactoryGirl.attributes_for(:search_order,
																					:search_queries_attributes => search_queries_attributes)
					end

					it 'should be success' do
						response.should be_success
					end

					it 'should render template index' do
						response.should render_template('index')
					end

					it 'should return error messages for search_queries.content' do
						search_order = assigns(:search_order)						
						search_order.errors["search_queries.content"].should == ["can't be blank"]
					end
				end
			end
		end

		context 'valid search_order' do	
			context 'stubbed search library' do
				let(:search_string1) { 'google' }
				let(:search_string2) { 'yahoo' }
				let(:search_queries_attributes) do
					[ 
						FactoryGirl.attributes_for(:exact_search_query, :content => search_string1),
						FactoryGirl.attributes_for(:and_search_query, :content => search_string2) 
					]
				end

				let(:search_order_attributes) do
					FactoryGirl.attributes_for(:search_order, :search_queries_attributes => search_queries_attributes)
				end

				before(:each) do
					search_main = stub('search_main')
					search_main.should_receive('search')
					Search::Main.should_receive(:new).and_return(search_main)
					post :create , :search_order => search_order_attributes
				end

				it 'should be success' do
					response.should be_success
				end

				it 'should render_template index' do
					response.should render_template('index')					
				end

				it 'should create a new search order' do
					SearchOrder.count.should == 1
				end

				it 'should create associated search queries' do
					search_order = SearchOrder.last
					search_order.search_queries.size.should == 2

					exact_search_query = search_order.search_queries.find_by_status(SearchQuery::STATUSES[:EXACT])
					exact_search_query.content.should == search_string1
					
					and_search_query = search_order.search_queries.find_by_status(SearchQuery::STATUSES[:AND])
					and_search_query.content.should == search_string2
				end
			end
		end
	end
end