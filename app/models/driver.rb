class Driver < ActiveRecord::Base
  attr_accessible :name, :passport
  
  validates :name,      :presence => true
  validates :passport,  :presence => true
  
  belongs_to :company
  
  def self.company_driver(company)
    Driver.where("company_id = ?", company)
  end
end
