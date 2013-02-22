require 'spec_helper'

describe 'Search::SearchString'	do
	subject { Search::SearchString.new(search_order) }
	
	describe '#string_from_search_queries' do		
		context 'and search_queries' do			
			let(:search_order) { FactoryGirl.build(:search_order) }
			let(:search_content) { 'All should be included' }
			let(:expected_search_string) { 'All should be included' }	
			let(:search_query) { FactoryGirl.build(:and_search_query , :content => search_content)}

			before(:all) do
				search_order.search_queries << search_query
			end

			its(:string_from_search_queries) { should include(expected_search_string) }
		end
	
		context 'exact search_queries' do
			let(:search_order) { FactoryGirl.build(:search_order) }
			let(:search_content) { '"exact" sear"ch' }
			let(:expected_search_string) { '"exact search"' }	
			let(:search_query) { FactoryGirl.build(:exact_search_query , :content => search_content)}

			before(:all) do
				search_order.search_queries << search_query
			end

			its(:string_from_search_queries) { should include(expected_search_string) }
		end

		context 'excluded search_queries' do
			let(:search_order) { FactoryGirl.build(:search_order) }
			let(:search_content) { '5 - 4' }
			let(:expected_search_string) { '-5 -- -4' }	
			let(:search_query) { FactoryGirl.build(:excluded_search_query , :content => search_content)}

			before(:all) do
				search_order.search_queries << search_query
			end

			its(:string_from_search_queries) { should include(expected_search_string) }			
		end	

		context 'OR search_queries' do
			let(:search_order) { FactoryGirl.build(:search_order) }
			let(:search_content) { '-word1 word2 -' }
			let(:expected_search_string) { 'word1 OR word2' }	
			let(:search_query) { FactoryGirl.build(:or_search_query , :content => search_content)}

			before(:all) do
				search_order.search_queries << search_query
			end

			its(:string_from_search_queries) { should == expected_search_string }			
		end

		context 'synonym search_queries' do
			let(:search_order) { FactoryGirl.build(:search_order) }
			let(:search_content) { '-word1 word2 -' }
			let(:expected_search_string) { '~-word1 ~word2 ~-' }	
			let(:search_query) { FactoryGirl.build(:synonym_search_query , :content => search_content)}

			before(:all) do
				search_order.search_queries << search_query
			end

			its(:string_from_search_queries) { should == expected_search_string }			
		end

		context 'allinurl search_queries' do
			let(:search_order) { FactoryGirl.build(:search_order) }
			let(:search_content) { 'Should only search this in url' }
			let(:expected_search_string) { 'allinurl:Should only search this in url' }	
			let(:search_query) { FactoryGirl.build(:allinurl_search_query , :content => search_content)}

			before(:all) do
				search_order.search_queries << search_query
			end

			its(:string_from_search_queries) { should == expected_search_string }			
		end

		context 'allintitle search_queries' do
			let(:search_order) { FactoryGirl.build(:search_order) }
			let(:search_content) { 'Should only search this in url' }
			let(:expected_search_string) { 'allintitle:Should only search this in url' }	
			let(:search_query) { FactoryGirl.build(:allintitle_search_query , :content => search_content)}

			before(:all) do
				search_order.search_queries << search_query
			end

			its(:string_from_search_queries) { should == expected_search_string }			
		end
	end

	describe '#string_from_domain_names' do
		context "when websites is not empty" do
			let(:search_order) { FactoryGirl.build(:search_order) }
			let(:domain_name1) { 'www.yahoo.com' }
			let(:domain_name2) { 'http://www.google.com' }

			let(:website1) { FactoryGirl.build(:website, :domain_name => domain_name1) }
			let(:website2) { FactoryGirl.build(:website, :domain_name => domain_name2) }
			let(:expected_search_string) { "site:http://#{domain_name1} OR site:#{domain_name2}" }

			before(:all) do
				search_order.websites << website1
				search_order.websites << website2
			end

			its(:string_from_domain_names) { should == expected_search_string }
		end

		context "when websites is empty" do
			let(:search_order) { FactoryGirl.build(:search_order) }
			let(:expected_search_string) { "" }

			its(:string_from_domain_names) { should == expected_search_string }
		end
	end

	describe '#to_s' do
		let(:search_order) { FactoryGirl.build(:search_order) }
		let(:string_from_domain_names) { 'site:http://www.google.com OR site:http://www.yahoo.com' }
		let(:string_from_search_queries) { 'word1 word2' }
		let(:expected_to_s) { 'word1 word2 site:http://www.google.com OR site:http://www.yahoo.com' }
		
		it 'should return valid search string' do 
			subject.should_receive(:string_from_domain_names).and_return(string_from_domain_names)
			subject.should_receive(:string_from_search_queries).and_return(string_from_search_queries)
			subject.to_s.should == expected_to_s 
		end 
	end
end 