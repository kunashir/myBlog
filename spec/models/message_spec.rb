require 'spec_helper'

describe Message do
  before(:each) do
    @msg = FactoryGirl.create :message

  end

  it "should create a new instance given valid attribures" do
    #User.create!(@attr)
    @msg.should be_valid
  end

  it "should be saving" do
    @msg.save
  end

  describe "relation with user" do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    it "can have relation to user" do
      @msg.users<<@user
      @msg.users.include?(@user)
    end
  end
end
# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

