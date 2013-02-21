class SearchOrder < ActiveRecord::Base
	has_many :search_queries, :dependent => :destroy
	accepts_nested_attributes_for :search_queries
	attr_accessible :search_type, :status, :total_results

	STATUSES = {
		:PENDING  => 'pending',
		:ERROR 		=> 'error',
		:FINISHED => 'finished'
	}

	SEARCH_TYPES = {
		:LINK     => 'link',
		:IMAGE    => 'image',
		:DOCUMENT => 'document'
	}

	MIN_SEARCH_QUERY = 1
	validate  :has_at_least_1_search_query
	validates :status, :search_type, :presence  => true
	validates :status, :inclusion => { :in => STATUSES.values }
	validates :search_type, :inclusion => { :in => SEARCH_TYPES.values }
	validates :total_results, :numericality => { :greater_than => 0 }

	private

	def has_at_least_1_search_query
		self.errors[:base] << 'At least 1 search query must be presented' if self.search_queries.blank?
	end
end
