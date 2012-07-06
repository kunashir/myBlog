class Area < ActiveRecord::Base

	def self.get_selector
		areas = Area.select("id, name")
		array_to_selector = Array.new
		i = 0
		for ar in areas
			sub_arr = Array.new
			sub_arr[1] = ar.id
			sub_arr[0] = ar.name
			array_to_selector[i] = sub_arr
			i = i + 1
		end
		return array_to_selector
	end
end
