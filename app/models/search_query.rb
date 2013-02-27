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

	MAPPED_STATUSES = [
		["Exactly", "exact"], ["Excluded", "excluded"], ["And", "and"],
		 ["Or", "or"], ["Synonym", "synonym"], ["Only search in url", "allinurl"], ["Only search in title", "allintitle"]
	]

	belongs_to :search_order

	validates :content, :status, :presence => true
	validates :status, :inclusion => { :in => STATUSES.values }

  attr_accessible :content, :search_order_id, :status
end
