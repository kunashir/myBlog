class Avto < ActiveRecord::Base
  # attr_accessible :model, :carcase, :statenumber, :trailnumber
  
  validates :statenumber, :presence => true, :length => {:minimum => 6}
  
  belongs_to :company

  before_save :set_shortname
  
  def self.company_avto(company)
    Avto.where("company_id = ?", company)
  end
end

private

	def set_shortname
		self.shortname = self.model + ", " + self.statenumber
	end
