class UserMsg < ActiveRecord::Base
  attr_accessible :active
  belongs_to :user
  belongs_to :message

  validates :user,    :presence => true
  validates :message, :presence => true

  def self.for_user(user)
    UserMsg.where("user_id = ?", user)
  end
end
