class City < ActiveRecord::Base
	validates :name, :presence  => true, :uniqueness => { :case_sensitive => false }
	has_many	:storages
	 
	def self.load_cities(fileName)
		lines = File.readlines(fileName)
		for line in lines
			curCity = City.new	
			curCity.name = line	
			curCity.save!
		end
	end
	
	def self.find_city(some_name)
		where("name LIKE ?", "#{some_name}%").first
	end
end
