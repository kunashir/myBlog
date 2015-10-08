class UserMsg < ActiveRecord::Base
  # attr_accessible :active
  
  belongs_to :user
  belongs_to :message

  validates :user,    :presence => true
  validates :message, :presence => true

  def self.for_user(user)
    UserMsg.includes(:message).where("user_id = ? and active = ?", user, true)
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

