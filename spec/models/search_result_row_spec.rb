require 'spec_helper'

describe 'SearchResultRow' do
	subject { SearchResultRow }
	let(:attrs) do
		{ 
			:title => 'title',
			:description => 'description',
			:href => 'http://www.yahoo.com'
		}
	end
	
	let(:attrs1) do
		{ 
			:title => 'title1',
			:description => 'description1',
			:href => 'http://www.yahoo1.com'
		}
	end

	describe '#to_object' do
		it 'should return an object with attributes equal to given attributes' do
			search_result_row = SearchResultRow.to_object(attrs)
			search_result_row.should be_a SearchResultRow
			search_result_row.title.should == attrs[:title]
			search_result_row.description.should == attrs[:description]
			search_result_row.href.should == attrs[:href]
		end
	end

	describe '#to_objects' do
		
		let(:search_result_rows) { SearchResultRow.to_objects(array_of_attrs) }
		context 'when an empty array is given' do
			let(:array_of_attrs) { [  ] }
			it 'should return an empty array' do
				search_result_rows.size.should == 0
			end
		end

		context 'when a not empty array is given' do
			let(:array_of_attrs) { [ attrs, attrs1 ] }
			it 'should return an array of SearchResultRow' do
				search_result_rows.size.should == 2
				[attrs, attrs1].each do |attr|
					search_result_rows.map(&:title).should include attr[:title]
					search_result_rows.map(&:description).should include attr[:description]
					search_result_rows.map(&:href).should include attr[:href]
				end
			end
		end	
	end
end