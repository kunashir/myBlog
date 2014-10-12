class Lot < ActiveRecord::Base
  attr_accessible :current_summa, :description, :start_date, :start_summa, :step, :title
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

