class SearchResultRow
	attr_accessor :title, :href, :description

	def attributes= (attrs)
		(attrs || {}).each do |key, value|
			send("#{key}=", value)
		end	
	end

	def self.to_object(attrs)
		srr = SearchResultRow.new
		srr.attributes = attrs
		srr
	end

	def self.to_objects(array_of_attrs)
		search_results = []
		(array_of_attrs || []).each do | attrs |
			search_results << self.to_object(attrs)
		end
		search_results
	end
end