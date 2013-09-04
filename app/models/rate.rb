#coding: utf-8

class Rate < ActiveRecord::Base
	attr_accessible	:area_id, :city_id, :carcase, :summa
	
	belongs_to	:area,	:class_name => "City", :foreign_key => "area_id"
	belongs_to	:city
	
	validates :area_id,            :presence => true #площадка - это город, в котором площадка находится
	validates :city_id,            :presence => true
	validates :carcase,         :presence => true
	validates :summa,           :presence => true
	
	def get_name
		self.area.name + " - " + self.city.name + " (" + self.carcase + ")"
	end
	
	def get_summa
		self.summa
	end
	
	def get_area
		self.area.name
	end
	
	def get_city
		self.city.name
	end
	
	def self.find_rate(area, city, carcase)
		Rate.where('area_id = ? AND city_id = ? AND carcase = ?', area, city, carcase).first
	end
	
	def self.load_from_file(filename, city)
		lines = File.readlines(filename)
		#area_item = Area.find_by_name(area_name)
		lines.each do |line|
			data_array    	= line.split(",")#[0] - город, [1] - сумма тент, [2] - сумма термос, [3] - сумма реф
			cur_city		= City.find_city(data_array[0])
			next if cur_city.nil?
			
			for i in [1,2,3]
				add_rate(city, cur_city, i, data_array[i].to_i)
			end
		end
	end
		
private	
		
	def self.add_rate(area_item, city, code_carcase, summa) # code_carcase (1 - тент, 2 - темрос, 3 - реф
		carcase = "тент"
		if code_carcase == 2
			carcase = "термос"
		elsif code_carcase == 3
			carcase = "реф"
		end 
		newRate 		= Rate.new
		newRate.city 	= city
		newRate.area 	= area_item
		newRate.carcase = carcase
		newRate.summa	= summa
		newRate.save
	end
		
end
