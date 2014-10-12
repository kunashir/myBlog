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
# == Schema Information
#
# Table name: transportations
#
#  id                :integer         not null, primary key
#  num               :integer
#  date              :date
#  time              :time
#  storage_source    :string(255)
#  storage_dist      :string(255)
#  comment           :string(255)
#  type_transp       :string(255)
#  weight            :decimal(, )
#  carcase           :string(255)
#  start_sum         :integer
#  cur_sum           :integer
#  step              :integer
#  manager_id        :integer
#  carrier_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  company_id        :integer
#  volume            :string(255)
#  avto_id           :integer
#  driver_id         :integer
#  client_id         :integer
#  storage_id        :integer
#  specprice         :boolean
#  request_abort     :boolean         default(FALSE)
#  abort_company     :integer
#  area_id           :integer
#  rate_id           :integer
#  time_last_action  :datetime
#  complex_direction :boolean
#  extra_pay         :integer         default(0)
#  city_id           :integer
#

