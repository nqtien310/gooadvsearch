require 'spec_helper'

describe SearchOrder do
  it { should have_many(:search_queries) }
  it { should have_many(:websites) }
  it { should accept_nested_attributes_for(:search_queries) }

  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:search_type) }
  it { should ensure_inclusion_of(:search_type).in_array( SearchOrder::SEARCH_TYPES.values ) }
  it { should ensure_inclusion_of(:status).in_array( SearchOrder::STATUSES.values ) }
  it { should validate_numericality_of(:total_results) }
  
  subject { FactoryGirl.build(:search_order) }

  describe 'save' do
  	describe 'search_queries' do
  		context 'is empty' do
  			its(:save) { should be_false }
  		end

  		context 'is not empty' do
  			let(:search_query) { FactoryGirl.build(:exact_search_query) }
  			before(:all) { subject.search_queries << search_query }
  			its(:save) { should be_true }        
  		end
  	end
  end
end
