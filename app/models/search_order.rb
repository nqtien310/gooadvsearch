class SearchOrder < ActiveRecord::Base
	has_many :websites, :dependent => :destroy do
		def <<(website)
			super if website.valid?
		end
	end
	
	has_many :search_queries, :dependent => :destroy

	attr_accessible :search_type, :status, :total_results, :search_queries_attributes, :websites_attributes
	accepts_nested_attributes_for :search_queries, :websites

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
	DEFAULT_TOTAL_RESULTS = 10

	validate  :has_at_least_1_search_query
	validates :status, :search_type, :presence  => true
	validates :status, :inclusion => { :in => STATUSES.values }
	validates :search_type, :inclusion => { :in => SEARCH_TYPES.values }
	validates :total_results, :numericality => { :greater_than => 0 }


	after_initialize do
		if self.new_record?
			self.search_type ||= SEARCH_TYPES[:LINK]
			self.total_results ||= DEFAULT_TOTAL_RESULTS
			self.websites.select! do |website|
				website.valid?
			end
		end
	end


	state_machine :status , :initial => STATUSES[:PENDING] do
		event :finish do
			transition STATUSES[:PENDING] => STATUSES[:FINISHED] 
		end

		event :error do
			transition STATUSES[:PENDING] => STATUSES[:ERROR] 
		end
	end


	def build_default_return_websites
		Website::DEFAULT_RETURN_WEBSITES.each do |domain_name|
			self.websites.build(:domain_name => domain_name)
		end
	end	

	def websites= (websites)
		websites.each do |website|
			self.websites << website
		end		
	end

	private

	def has_at_least_1_search_query
		self.errors[:base] << 'At least 1 search query must be presented' if self.search_queries.blank?
	end
end