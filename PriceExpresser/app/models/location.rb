class Location < ActiveRecord::Base
	geocoded_by :address
	after_validation :geocode
	def to_param
  		address
	end
end
