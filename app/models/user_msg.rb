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
