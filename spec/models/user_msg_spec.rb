require 'spec_helper'

describe UserMsg do
  before(:each) do
    @user_msg = FactoryGirl.create :user_msg
  end

  it "must have a user" do
    @user_msg.user.should_not be_nil
  end

  it "must have a message" do
    @user_msg.message.should_not be_nil
  end

  it "not valid without user" do
    @user_msg.user = nil
    @user_msg.should_not be_valid
  end

  it "not valid without message" do
    @user_msg.message = nil
    @user_msg.should_not be_valid
  end

  it "return all active messages for user" do
    UserMsg.for_user(@user).include?(@user_msg.message)
  end

end
# == Schema Information
#
# Table name: user_msgs
#
#  id         :integer         not null, primary key
#  active     :boolean         default("t")
#  user_id    :integer
#  message_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

