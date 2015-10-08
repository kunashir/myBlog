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
# == Schema Information
#
# Table name: avtos
#
#  id          :integer         not null, primary key
#  model       :string(255)
#  carcase     :string(255)
#  statenumber :string(255)
#  trailnumber :string(255)
#  company_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  shortname   :string(255)
#

