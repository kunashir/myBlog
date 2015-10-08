# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Message < ActiveRecord::Base
  # attr_accessible :content

  has_many   :users, through: :user_msg
  has_many   :user_msg
end

