class Website < ActiveRecord::Base
	belongs_to :search_order
  attr_accessible :domain_name

	validates_format_of :domain_name,
										  :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/

	def domain_name=(dn)		
		if ( dn =~ /^(http|https):\/\// ).present?
			self[:domain_name] = dn
		else
			self[:domain_name] = "http://#{dn}" 		
		end
	end
end