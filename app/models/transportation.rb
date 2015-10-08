#coding: utf-8
#require 'date'

#include ActionView::Helpers


class Transportation < ActiveRecord::Base
  #apply_simple_captcha
  # attr_accessible  :num, :date, :time, :comment,
  #   :type_transp, :weight, :carcase, :start_sum, :cur_sum, :step, :company_id, :volume,
  #   :client_id, :storage_id, :abort_company, :area_id, :company, :city_id, :complex_direction, :extra_pay

  belongs_to  :user, :foreign_key => "manager_id"
  belongs_to  :company
  belongs_to  :avto
  belongs_to  :driver
  belongs_to  :client
  belongs_to  :storage
  belongs_to  :area
  belongs_to  :rate
  belongs_to  :city # March 2014 - new relation

  #validates :user_id, :presence => true
  validates :date,            :presence => true
  validates :carcase,         :presence => true
  validates :step,            :presence => true

  default_scope {order('transportations.id  DESC')} #сортировка по уменьшению ид

  before_save   :logging
  before_save    :set_rate
  before_save   :set_time
  after_save    :logging_new
  @cur_user = nil

  accepts_nested_attributes_for :avto
  accepts_nested_attributes_for :driver

  scope :confirmed, ->(company){
    if company.is_freighter?
      where(company: company).where.not(avto: nil, driver: nil)
    else
      where.not(avto: nil, driver: nil, company: nil)
    end
  }
  scope :not_confirmed, ->(company){
    if company.is_freighter?
      where(company: company, avto: nil, driver: nil)
    else
      where.not(company: nil).where(avto: nil, driver: nil)
    end
  }
  scope :active, ->(){where("date >= '#{Date.today.strftime('%Y-%m-%d')}' AND company_id IS NULL")}

def bet(specprice=0)
  if specprice == 0
    start_summa = (cur_sum.nil? or cur_sum == 0) \
          ? (rate_summa + step): cur_sum
    self.cur_sum = start_summa - step
  else
    self.cur_sum = (rate_summa)*(1 - specprice/100.00)
    self.specprice = true
  end
end

def to_s
  begin
    "#{area.name} - #{city.name}"
  rescue
    "Н/д"
  end
end

#=======================================================================
def get_num
  num.nil? ? "без номера" : num
end

#=======================================================================

def get_storage
  unless storage.nil?
    storage.name
  else
    city.name unless city.nil?
  end
end
#=======================================================================

def lightcar?
  return false if weight.nil?
  weight.to_i < 11
end

#=======================================================================
  def get_area

    return storage_source if area.nil?

    return area.name
  end

#=======================================================================
  def set_user(user)
    @cur_user = user
  end

#=======================================================================
  def self.transportation_for_date(some_date)
    if some_date.to_s.empty?
      Transportation.all
    else
      Transportation.where("date = ?", some_date)
    end
  end

#=======================================================================
def self.set_filter(date, show_all, source_storage, hide_today, page, per_page)
  return Transportation.includes(:area, :city, :client, :company).page(page).per(per_page) if show_all

  return Transportation.active.page(page).per(per_page) if date.blank?

  request_text = "date = ?"
  request_date = date
  if date.nil? or date.empty?
    if hide_today
      request_text = "date > ? AND (last_bid_at > '#{Time.now.beginning_of_day}' OR last_bid_at IS NULL)"
    else
      request_text = "date >= ?"
    end
    request_date = Date.current
  end
  #beginning_of_day = Time.now.beginning_of_day
  if !source_storage.nil? and !source_storage.empty?
    request_text += " AND area_id = ?"
    return Transportation.includes(:area, :city, :client, :company).where(request_text, request_date, source_storage).
page(page).per(per_page)
  end
  Transportation.includes(:area, :city, :client, :company).where(request_text, request_date).page(page).per(per_page)
end

#=======================================================================
  def self.only_active
    Transportation.where("date >= ?", Date.current)
  end

#=======================================================================
  def self.format_date(dd)
    if /([0-9]{2}).([0-9]{2}).([0-9]{2})/ =~ dd
      return "20" + $3 + "-" + $2 + "-" + $1
    elsif /([0-9]{2}).([0-9]{2}).([0-9]{4})/ =~ dd #format like DD.MM.YYYY
      return $3 + "-" + $2 + "-" + $1
    end
    return dd
  end

#=======================================================================
  def self.load_from_file(filename, manager)
    lines = File.readlines(filename)
    lines.each do |line|
      # Обрабатываем одну перевозку, надо найти клиента, склад
      # остальное проcто текст/число
      data_array    = line.split(";")
      client        = Client.find_by_name(data_array[2])
      #dist_storage  = Storage.client_storage(client,data_array[4])
      my_storage    = data_array[5]

      tr            = Transportation.new
      tr.num        = data_array[3]
      tr.date       = format_date(data_array[0])
      tr.time       = data_array[11]
      tr.client     = client
      #tr.storage    = dist_storage
      tr.city       = City.find_city(data_array[4])
      area          = Area.find_by_name(my_storage)
      tr.area       = area
      tr.weight     = data_array[6]
      tr.volume     = data_array[7]
      comment_text  = data_array[8]
      carcase       = "термос"
      # Парсим коммент - если там есть запятая, то все что до нее в
      # тип кузова, остальное в коммент, иначе тип кузова будет тент
      if /(\W+),(\W+)\s/i =~ comment_text
        carcase   = $1.downcase
        comment   = $2
      else
        comment   = comment_text
      end
      tr.comment  = comment_text
      if area.nil? or tr.city.nil?
        tr.rate = nil
      else
        tr.rate    = Rate.find_rate(area, tr.city, carcase)
      end
      tr.carcase  = carcase
      tr.start_sum  =  tr.rate.get_summa(tr.weight) unless tr.rate.nil? #data_array[10].sub(" ", "")
      tr.step       = 500
      tr.user       = manager unless manager.nil?
      tr.save
    end
  end

#=======================================================================
def is_obsolete?
  self.date < Date.current()
end
#=======================================================================
  
def is_active? #заявка активна если дата заявки не меньше текущей даты!
  # if self.date >= Date.current()
  #   return true
  # end
  # return false
  self.date >= Date.current()
end


  # def is_active? #заявка активна если дата заявки не меньше текущей даты!
  #   return false unless self.date >= Date.current()
  #   start_time_list = APP_CONFIG["time_start"].split(",")
  #   stop_time_list = APP_CONFIG["time_stop"].split(",")
  #   start2 = Time.parse("#{Date.today} #{start_time_list[1]}:00")
  #   start1 = Time.parse("#{Date.today} #{start_time_list[0]}:00")
  #   stop1 = Time.parse("#{Date.today} #{stop_time_list[0]}:00")
  #   cur_time    =   Time.zone.now.localtime
  #   if !is_busy? && created_at < start1
  #     #не закрытая заявка, созданная до первого старта
  #     return true
  #   elsif !is_busy? && created_at > start1 
  #     #заявка созданая после первых торгов
  #     return true
  #   elsif is_busy? && created_at >= start1 && cur_time < start2
  #     return true
  #   elsif is_busy? && created_at < start1 && cur_time < stop1
  #     return false
  #   end
  #   true
  # end

#=======================================================================#=======================================================================
  def is_confirm? #заявка подтверждена, когда есть данные по машине и водителю

    ( !self.avto_id.nil? and !self.driver_id.nil?)

  end

#=======================================================================
  def is_busy? #заявка занята, когда есть данные по перевозчику
    return  !self.company.nil?  # ? false : true
  end

#=======================================================================
  def is_today? #это сегодняшняя заявка
    return self.date == Date.current() #true if
  end

#=======================================================================
  def logging
    if !self.id.nil?
      tr_in_base = Transportation.find(self.id)
      @new_rec = false
    else
      @new_rec  = true
      return true
    end
    attr_hash = self.attributes
    keys      = attr_hash.keys
    old_attr_hash = tr_in_base.attributes
    for key in keys
      if key == :created_at or key == :update_at #служебные поля пропускаем
        next
      end
      if old_attr_hash[key] != attr_hash[key]
        Log.save_log_record(self, @cur_user, key, old_attr_hash[key],'edit record', @cur_user.company)
      end
    end


  end

#=======================================================================
  def logging_new
    if !@new_rec
      return true
    end
    attr_hash = self.attributes
    keys      = attr_hash.keys
    for key in keys
        Log.save_log_record(self, self.user, key, nil, 'new record', self.user.company)
    end
  end

#=======================================================================
  def as_xls(option = {})
      {
        "Rasp"   => num,
        "Date"    => date,
        "Storage source"  => storage_source,
        "comment"  => comment,
        "Weigth"  => weight,
        "carcase"  => carcase,
        "start sum"  => start_sum,
        "Cur sum"  => cur_sum,
        "company"    => company
      }
  end

#=======================================================================
  def have_spec_price?
    return  !(specprice.nil? or !specprice ) # ? false : true
  end

#=======================================================================
  def get_volume
   volume
  end

#=======================================================================
  def rate_summa
    sum = start_sum || 0
    extp = extra_pay || 0
    if complex_direction
      sum += (extp || 0)
    end
    return sum
  end

#=======================================================================
  def set_rate
    #если нач. сумма уже есть, ничего не делаем
    #для ручного редактирования
    return true if !self.start_sum.nil?

    if self.area.nil? or self.storage.nil?
      return true
    end
    temp = Rate.find_rate(self.area.city, self.storage.city, self.carcase.downcase)

    return true if temp.nil?

    self.rate = temp
    self.start_sum = temp.get_summa
    return true
  end

  #=======================================================================
  def set_time
    self.time_last_action =  Time.now
  end

  #=======================================================================
  def get_time
    if self.time_last_action.nil?
      return Time.new(1900-01-01)
    end
    return self.time_last_action.getlocal + 300
  end
  #=======================================================================
  def close_time
    if self.time_last_action.nil?
      return Time.new(1900-01-01)
    end
    return self.time_last_action.getlocal + 300
  end
  #=======================================================================
  def is_close?
    Time.now > get_time
  end

end
# == Schema Information
#
# Table name: transportations
#
#  id                :integer         not null, primary key
#  num               :integer
#  date              :date
#  time              :time
#  storage_source    :string(255)
#  storage_dist      :string(255)
#  comment           :string(255)
#  type_transp       :string(255)
#  weight            :decimal(, )
#  carcase           :string(255)
#  start_sum         :integer
#  cur_sum           :integer
#  step              :integer
#  manager_id        :integer
#  carrier_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  company_id        :integer
#  volume            :string(255)
#  avto_id           :integer
#  driver_id         :integer
#  client_id         :integer
#  storage_id        :integer
#  specprice         :boolean
#  request_abort     :boolean         default("f")
#  abort_company     :integer
#  area_id           :integer
#  rate_id           :integer
#  time_last_action  :datetime
#  complex_direction :boolean
#  extra_pay         :integer         default("0")
#  city_id           :integer
#  last_bid_at       :datetime
#

