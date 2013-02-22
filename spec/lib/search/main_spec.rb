	require 'spec_helper'

describe 'Search::Main' do
	subject { Search::Main.new }

	describe '#search' do
		it 'should invoke #submit_search_form_with and #to_array_of_hash with search string value' do
			search_result_page = double('search_result_page')
			nokogiri_elements = double('nokogiri_elements')
			subject.should_receive(:submit_search_form_with).with(subject.search_string).once.and_return(search_result_page)
			subject.should_receive(:to_array_of_nokogiri_elements).with(search_result_page).once.and_return(nokogiri_elements)					
			subject.should_receive(:to_array_of_hashes).with(nokogiri_elements).once			
			subject.search
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
				result[0][:text].should == 'YahooMailWebsite'
				result[0][:description].should == 'This is yahoo website'
				result[1][:href].should == 'http://www.google.com'
				result[1][:text].should == 'google'
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