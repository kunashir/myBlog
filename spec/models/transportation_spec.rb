require 'spec_helper'
require 'transportations_helper'

describe Transportation do
  #before(:each) do
  include ActionView::Helpers
  let(:tr) { FactoryGirl.create :transportation }
  let(:tr_extra) { FactoryGirl.create :tr_extra }
  #end

  it "should create a new instance given valid attribures" do
    #User.create!(@attr)
    expect(tr).to be_valid
  end

  describe "Complex directions" do
    it "have extra pay" do
      tr.complex_direction = true
      tr.extra_pay = 1000
      expect(tr.extra_pay).not_to eq(0)
    end

    it "rate summa with extra pay" do
      expect(tr_extra.rate_summa).to eq(tr_extra.start_sum + tr_extra.extra_pay)
    end

    it "rate summa without extra pay" do
      expect(tr.rate_summa).to eq(tr.start_sum)
    end

    it "consider a flag of complex direction" do
      tr_extra.complex_direction = false
      expect(tr_extra.rate_summa).to eq(tr_extra.start_sum)
    end
  end

  describe "set current summa for transportation" do
    it "A first stake must be set to a starting sum" do
      tr.bet #simple rate, not a specprice
      expect(tr.cur_sum).to eq(tr.rate_summa)
    end

    it "not a first bet" do
      tr.bet
      tr.bet
      expect(tr.cur_sum).to eq(tr.rate_summa - tr.step)
    end

    describe "bet with specprice"  do
      before(:each) do
        tr.bet(percent_spec_price)
      end
      it "sum minus specprice percent" do
        expect(tr.cur_sum).to eq(tr.rate_summa*(1 - percent_spec_price/100.00))
      end

      it "change attribute specprice" do
        expect(tr.specprice).to be true
      end
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
#  request_abort     :boolean         default("f")
#  abort_company     :integer
#  area_id           :integer
#  rate_id           :integer
#  time_last_action  :datetime
#  complex_direction :boolean
#  extra_pay         :integer         default("0")
#  city_id           :integer
#  last_bid_at       :datetime
#

