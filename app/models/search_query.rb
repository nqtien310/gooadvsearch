class SearchQuery < ActiveRecord::Base
	STATUSES = {
		:EXACT    => 'exact',
		:EXCLUDED => 'excluded',
		:ANY 		  => 'any'
	}

	belongs_to :search_order

	validates :content, :status, :presence => true
	validates :status, :inclusion => { :in => STATUSES.values }

  attr_accessible :content, :search_order_id, :status
end
