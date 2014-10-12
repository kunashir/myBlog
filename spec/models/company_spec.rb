require 'spec_helper'

describe Company do
  before(:each) do
    @transport_company = FactoryGirl.create :fr
    @waster = FactoryGirl.create :waste_byer
    @other_seller = FactoryGirl.create :other_seller
  end

  
end
# == Schema Information
#
# Table name: companies
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  inn          :integer
#  is_freighter :boolean
#  created_at   :datetime
#  updated_at   :datetime
#

