class Message < ActiveRecord::Base
  # attr_accessible :content

  has_many   :users, through: :user_msg
  has_many   :user_msg
end
