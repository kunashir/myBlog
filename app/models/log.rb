#coding: utf-8

class Log < ActiveRecord::Base
  #Одна запись лога связана с одним пользователем и одной заявкой
  belongs_to :user
  belongs_to :transportation
  belongs_to :company
  
  def self.save_log_record(object, user, attr, oldvalue, action, company)
    new_rec = Log.new
    new_rec.transportation  = object
    new_rec.user            = user
    new_rec.attr            = attr
    new_rec.oldvalue        = oldvalue
    new_rec.action          = action
    new_rec.company         = company
    new_rec.save!
  end

  def self.company_has_stake(transp, company) #Компания имеет движения по ставке
    rec_in_logs = Log.where("transportation_id = ? AND company_id = ?", transp, company)
    #Если выборка не пустая значит имеет!
    !rec_in_logs.empty?
  end
end
# == Schema Information
#
# Table name: logs
#
#  id                :integer         not null, primary key
#  transportation_id :integer
#  user_id           :integer
#  attr              :string(255)
#  oldvalue          :string(255)
#  action            :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  company_id        :integer
#

