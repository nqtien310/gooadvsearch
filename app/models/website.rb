class Website < ActiveRecord::Base
	belongs_to :search_order
  attr_accessible :domain_name

  validates :domain_name , :presence => true
end