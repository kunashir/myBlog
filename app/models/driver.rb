class Driver < ActiveRecord::Base
  attr_accessible :name, :passport
  
  validates :name,      :presence => true
  validates :passport,  :presence => true
  
  belongs_to :company
  
  def self.company_driver(company)
    Driver.where("company_id = ?", company)
  end
end
# == Schema Information
#
# Table name: drivers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  passport   :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

