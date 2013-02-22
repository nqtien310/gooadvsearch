class SearchQuery < ActiveRecord::Base
	STATUSES = {
		:EXACT       => 'exact',
		:EXCLUDED    => 'excluded',
		:AND 		     => 'and',
		:OR 		     => 'or',
		:SYNONYM     => 'synonym',
		:ALLINURL    => 'allinurl',
		:ALLINTITLE  => 'allintitle'
	}

	belongs_to :search_order

	validates :content, :status, :presence => true
	validates :status, :inclusion => { :in => STATUSES.values }

  attr_accessible :content, :search_order_id, :status
end
