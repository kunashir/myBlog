#coding: utf-8

class Log < ActiveRecord::Base
  #Одна запись лога связана с одним пользователем и одной заявкой
  belongs_to :user
  belongs_to :transportation
  belongs_to :company


  def self.transp_history(tr)
    Log.includes(:user, :company,:transportation).where("transportation_id" => tr, "attr" => "cur_sum").order(:transportation_id)
  end

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

  def self.company_refused?(tr, company)
    rec_in_logs = Log.where("transportation_id = ? AND company_id = ? AND action = ?", tr, company, "abort record")
    !rec_in_logs.empty?
  end

  def self.last_edit_from_company(tr, company)
    Log.where("transportation_id = ? AND company_id = ? AND action = ?", tr, company, "edit record").last(2)
  end

  def self.prev_summa(tr, company)
    Log.where("transportation_id = ? AND company_id = ? AND action = ? AND attr = ?",
      tr, company, "edit record", "cur_sum").last.oldvalue
  end

  def self.prev_company(tr, company)
    prev_value = Log.where("transportation_id = ? AND company_id = ? AND action = ? AND attr = ?",
      tr, company, "edit record", "company_id").last.oldvalue
    begin
      Company.find(prev_value)
    rescue
      nil #return nil, don't call the general handler for a jump to 404
    end
  end
end
