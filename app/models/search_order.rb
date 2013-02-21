class SearchOrder < ActiveRecord::Base
  attr_accessible :search_type, :status, :total_results
end
