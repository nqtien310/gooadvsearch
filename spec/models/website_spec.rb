require 'spec_helper'

describe Website do
  it { should belong_to(:search_order) }
  it { should validate_presence_of(:domain_name) }
end
