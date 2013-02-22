require 'spec_helper'

describe Website do
  it { should belong_to(:search_order) }  

  it { should allow_value('http://www.yahoo.com').for(:domain_name) }
  it { should allow_value('https://www.yahoo.com').for(:domain_name) }
  it { should allow_value('www.yahoo.com').for(:domain_name) }
  it { should allow_value('yahoo.com').for(:domain_name) }
  it { should_not allow_value('https://').for(:domain_name) }

  subject { FactoryGirl.build('website') }

  describe '#domain_name=' do
  	context 'with http:// or https://' do
  		let(:domain_name1) { 'http://www.yahoo.com' }
  		let(:domain_name2) { 'https://www.yahoo.com' }

  		it 'should be the same' do
  			subject.domain_name = domain_name1
  			subject.domain_name.should == domain_name1		

  			subject.domain_name = domain_name2
  			subject.domain_name.should == domain_name2
  		end
  	end

  	context 'without http:// or https://' do
  		let(:domain_name) { 'www.yahoo.com' }
  		it 'should automatically append http:// as prefix of domain_name' do
  			subject.domain_name = domain_name
  			subject.domain_name.should == "http://#{domain_name}"
  		end
  	end
  end
end
