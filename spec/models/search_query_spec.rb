require 'spec_helper'

describe SearchQuery do
  it { should belong_to(:search_order) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:status) }
  it { should ensure_inclusion_of(:status).in_array( SearchQuery::STATUSES.values ) }
end
