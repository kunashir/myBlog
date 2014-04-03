require 'spec_helper'

describe Transportation do
  before(:each) do
    @tr = FactoryGirl.create :transportation
  end

  it "should create a new instance given valid attribures" do
    #User.create!(@attr)
    @tr.should be_valid
  end

  describe "Complex directions" do
    it "have extra pay" do
      @tr.complex_direction = true
      @tr.extra_pay = 1000
      @tr.extra_pay.should_not == 0
    end
  end

  describe "test format date" do
    it "reduced format" do
      Transportation.format_date("01.01.14") == "2014-01-01"
    end

    it "full format" do
      Transportation.format_date("01.01.2014") == "2014-01-01"
    end
  end

end
