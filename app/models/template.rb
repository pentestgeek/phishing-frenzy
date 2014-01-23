class Template < ActiveRecord::Base
	has_many :campaigns

	attr_accessible :name, :description, :location, :notes

	validates :name, :presence => true, :length => { :maximum => 255 }
	validates :location, :presence => true, :length => { :maximum => 255 }

	before_validation :remove_spaces

	def remove_spaces
		self.location = self.location.parameterize("_")
	end
end
