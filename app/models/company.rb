#coding: utf-8
class Company < ActiveRecord::Base
  attr_accessible :name, :inn, :is_freighter
  
  has_many  :users
  has_many  :transportations
  has_many  :avto
  has_many  :drivers
  
  validates :name,    :presence => true

  def self.get_main_company
  	begin
  		return Company.find(1).name
  	rescue
  		return "Заведите основную компанию(она должена быть первой)"
  	end
  end
end
