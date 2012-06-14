#coding: utf-8

class Log < ActiveRecord::Base
  #Одна запись лога связана с одним пользователем и одной заявкой
  belongs_to :user
  belongs_to :transportation
  
  def self.save_log_record(object, user, attr, oldvalue, action)
    new_rec = Log.new
    new_rec.transportation  = object
    new_rec.user            = user
    new_rec.attr            = attr
    new_rec.oldvalue        = oldvalue
    new_rec.action          = action
    new_rec.save!
  end
end
