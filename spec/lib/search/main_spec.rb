	require 'spec_helper'

describe 'Search::Main' do
	subject { Search::Main.new(search_order) }
	let(:search_order) { nil }

	describe '#search' do
		it 'should invoke #submit_search_form_with and #to_array_of_hash with search string value' do
			search_result_page = double('search_result_page')
			nokogiri_elements = double('nokogiri_elements')
			subject.should_receive(:submit_search_form_with).with(subject.search_string).once.and_return(search_result_page)
			subject.should_receive(:to_array_of_nokogiri_elements).with(search_result_page).once.and_return(nokogiri_elements)					
			subject.should_receive(:to_array_of_hashes).with(nokogiri_elements).once			
			subject.search
		end

		let(:search_order) do
				search_order = FactoryGirl.build(:search_order)
				search_order.save(:validate => false)
				search_order
		end

		describe 'simple search_query' do		
			let(:search_results) do
				@search_results ||= subject.search
				@search_results
			end	

			let(:search_string) { 'google' }
			before(:all) do
			 FactoryGirl.create(:and_search_query, :content => search_string, :search_order => search_order)
			end

			context '#search_results' do
				it 'should has size equal to search_order\'s total_results' do
					search_results.size.should == search_order.total_results
				end

				it 'should contain hash elements' do
					search_results[0].should be_instance_of(Hash)
				end

				it 'should contain valid search results' do
					search_results.select do |r| 
						( r[:description] + r[:title] ).downcase.include?(search_string)
					end.size.should == search_order.total_results
				end
			end
		end

		describe 'complex search queries' do
			context 'with excluded' do
				before(:each) do
					FactoryGirl.create(:excluded_search_query, :content => excluded_search_string, :search_order => search_order)
					FactoryGirl.create(:exact_search_query, :content => exact_search_string, :search_order => search_order)
				end

				context 'with valid search tokens' do
					let(:excluded_search_string) { 'google' }
					let(:exact_search_string) { 'nqtien310' }

					let(:search_results) do
						@search_results ||= subject.search
						@search_results
					end

					it 'should return array with size equal to size of search_order\'s total_results' do
						search_results.size.should == search_order.total_results
					end

					it 'should return search results which contain exact_search_string' do
						search_results.each do |r|
							a = [ r[:description], r[:title], r[:href] ].join(' ').should be_include(exact_search_string)
						end
					end

					it 'should not return search results which contain excluded_search_string' do
						search_results.each do |r|
							a = [ r[:description], r[:title], r[:href] ].join(' ').should_not be_include(excluded_search_string)
						end
					end
				end

				context 'without valid search tokens' do
					let(:excluded_search_string) { 'google' }
					let(:exact_search_string) { 'nqtien310 should not exist here' }

					it 'should return an empty array' do
						search_results = subject.search
						search_results.should be_blank
					end	
				end
			end

			context 'with allinurl' do
				before(:each) do
					FactoryGirl.create(:allinurl_search_query, :content => search_string, :search_order => search_order)
				end

				let(:search_string) { search_tokens.join(' ')}

				context 'with valid search tokens' do
					let(:search_tokens) { %w(nqtien310 vndv) }
					
					it 'should return href contain at least 1 search token' do
						search_results = subject.search
						search_results.each do |r|
							search_tokens.should be_any{ |search_token| r[:href].downcase.include?(search_token) }
						end
					end
				end

				context 'with invalid search tokens' do
					let(:search_tokens) { %w(nqtien310 vndv this is invalid) }

					it 'should return empty array' do
						search_results = subject.search
						search_results.should be_blank
					end
				end
			end	

			context 'with allintitle' do
				let(:search_string) { search_tokens.join(' ')}

				before(:each) do
					FactoryGirl.create(:allintitle_search_query, :content => search_string, :search_order => search_order)
				end

				context 'with valid search tokens' do
					let(:search_tokens) { %w(google search) }
				
					it 'should return href contain at least 1 search token' do
						search_results = subject.search
						search_results.each do |r|
							search_tokens.should be_any{ |search_token| r[:title].downcase.include?(search_token) }
						end
					end
				end

				context 'with invalid search tokens' do
					let(:search_tokens) { %w(nqtien310 vndv this is invalid) }

					it 'should return empty array' do
						search_results = subject.search
						search_results.should be_blank
					end
				end
			end	
		end	
	end

	describe '#submit_search_form_with' do
		context 'when search string is not empty' do
			let(:search_string) { 'nqtien310' }
			it 'should return Mechanize page' do
				subject.submit_search_form_with(search_string).should be_instance_of(Mechanize::Page) 
			end
		end
		
		context 'when search string is empty' do
			let(:search_string) { '' }
			it 'should return Mechanize page' do
				subject.submit_search_form_with(search_string).should be_instance_of(Mechanize::Page) 
			end
		end
	end

	describe '#to_array_of_nokogiri_elements' do
		let(:total_results) { 50 }	
		let(:search_order) { FactoryGirl.build(:search_order , :total_results => total_results) }
		let(:search_query) { FactoryGirl.build(:exact_search_query, :content => search_string) }
		let(:nokogiri_elements) { subject.to_array_of_nokogiri_elements(@search_result_page) }


		before(:each) do
			search_order.search_queries << search_query
			@search_result_page = subject.submit_search_form_with(subject.search_string)
		end

		context 'with popular search string' do
			let(:search_string) { 'google' }

			it 'should return an array of nokogiri elements' do
				nokogiri_elements.first.class.should == Nokogiri::XML::Element
			end

			it 'should return an array with size equal to total_results' do
				nokogiri_elements.size.should == total_results
			end
		end
		
		context 'with non-exist search string' do
			let(:search_string) { 'should not gooadvsearch exist' }

			it 'should return an empty array' do
				nokogiri_elements.size.should == 0
			end
		end

		context 'with very rare search string' do
			let(:search_string) { 'nqtien310.wapto.me' }

			it 'should return an array of nokogiri elements' do
				nokogiri_elements.first.class.should == Nokogiri::XML::Element
			end

			it 'should return an array with size smaller than total_results' do
				nokogiri_elements.size.should < total_results
			end
		end
	end

	describe '#to_array_of_hashes' do
		context 'nokogiri_elements is not empty' do
			let(:first_row) do
				builder = Nokogiri::XML::Builder.new do |xml|	
					xml.li(:class => 'g'){
						xml.a(:href => 'http://www.yahoo.com') {
							xml.span 'Yahoo'
							xml.span 'Mail'
							xml.span 'Website'
						}
						xml.div(:class => 's'){
							xml.span 'This is yahoo website'
						}
					}
				end.doc
			end

			let(:second_row) do
				builder = Nokogiri::XML::Builder.new do |xml|	
					xml.li(:class => 'g'){
						xml.a(:href => 'http://www.google.com') {
							xml.span 'google'
						}
						xml.div(:class => 's'){
							xml.span 'This is google website'
						}
					}
				end.doc
			end

			let(:nokogiri_elements) { [first_row, second_row] }
			let(:result) { subject.to_array_of_hashes(nokogiri_elements) }

			it 'should return array of hash' do				
				result.should be_instance_of(Array)				
				result.first.should be_instance_of(Hash)
			end

			it 'should has the same size with size of nokogiri_elements' do
				result.size.should == nokogiri_elements.size
			end

			it 'should has element with value extracted from nokogiri_elements' do
				result[0][:href].should == 'http://www.yahoo.com'
				result[0][:title].should == 'YahooMailWebsite'
				result[0][:description].should == 'This is yahoo website'
				result[1][:href].should == 'http://www.google.com'
				result[1][:title].should == 'google'
				result[1][:description].should == 'This is google website'
			end
		end

		context 'nokogiri_elements is empty' do
			let(:nokogiri_elements) { [] }
			let(:result) { subject.to_array_of_hashes(nokogiri_elements) }

			it 'should return an empty array' do				
				result.should be_instance_of(Array)				
				result.size.should == 0
			end
		end
	end
end