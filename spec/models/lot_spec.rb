require 'rails_helper'

RSpec.describe Lot, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: lots
#
#  id            :integer         not null, primary key
#  title         :string(255)
#  description   :text
#  step          :integer
#  start_summa   :integer
#  current_summa :integer
#  start_date    :date
#  end_date      :date
#  for_selling   :boolean
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

