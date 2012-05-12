class Company < ActiveRecord::Base
  attr_accessible :name, :inn, :is_freighter
  
  has_many :users
  has_many :transportations
  
  validates :name,    :presence => true
end
