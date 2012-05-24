class Avto < ActiveRecord::Base
  attr_accessible :model, :carcase, :statenumber, :trailnumber
  
  validates :statenumber, :presence => true, :length => {:minimum => 6}
  
  belongs_to :company
  
  def self.company_avto(company)
    Avto.where("company_id = ?", company)
  end
end
