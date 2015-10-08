class Area < ActiveRecord::Base
	has_many  	:transportations
	belongs_to	:city

	def self.get_selector
		areas = Area.select("id, name")
		array_to_selector = Array.new
		i = 0
		#for ar in areas
		areas.each do |ar|
			sub_arr = Array.new
			sub_arr[1] = ar.id
			sub_arr[0] = ar.name
			array_to_selector[i] = sub_arr
			i = i + 1
		end
		return array_to_selector
	end

	def self.cities
		City.find_all_by_id(Area.select(:city_id))
	end
end
# == Schema Information
#
# Table name: areas
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  city_id    :integer
#

