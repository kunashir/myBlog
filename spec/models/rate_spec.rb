require 'spec_helper'

describe Rate do
  before(:each) do
    @rate = FactoryGirl.create :rate

  end

  it "should create a new instance given valid attribures" do
    #User.create!(@attr)
    @rate.should be_valid
  end

  it "return the rate using some parameters" do
    area = FactoryGirl.create :area #Area.where(FactoryGirl.attributes_for(:area)).first
    area.city = @rate.area
    @rate == Rate.find_rate(area, @rate.city, "термос")
  end

  it "rate for small car" do
    @rate.get_summa(9) == @rate.summa * 0.8
  end

  it "rate for normal car" do
    @rate.get_summa(18) == @rate.summa
  end


end