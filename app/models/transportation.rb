#coding: utf-8
#require 'date'

# include ActionView::Helpers


class Transportation < ActiveRecord::Base
  
	attr_accessible  :num, :date, :time, :storage_source, :storage_dist, :comment, :type_transp, :weight, :carcase, :start_sum, :cur_sum, :step, :company, :volume, :client_id, :storage_id, :abort_company, :area_id
  
  belongs_to  :user
  belongs_to  :company
  belongs_to  :avto
  belongs_to  :driver
  belongs_to  :client
  belongs_to  :storage
  belongs_to  :area
  
  #validates :user_id, :presence => true
  validates :date,            :presence => true
  #validates :time,            :presence => true #время ставят перевозчики
#  validates :area, 		 :presence => true
  # validates :storage_dist,    :presence => true
  # validates :type_transp,     :presence => true
  #validates :weight,          :presence => true
  validates :carcase,         :presence => true
  validates :start_sum,       :presence => true
  validates :step,            :presence => true
  default_scope               :order  =>  'transportations.id  DESC' #сортировка по уменьшению ид
  
  before_save   :logging
  after_save    :logging_new
  @cur_user = nil

  def get_area
    if area.nil?
      return storage_source
    end
    return area.name
  end

  def set_user(user)
	  @cur_user = user
  end
  
  def self.transportation_for_date(some_date)
    if some_date.to_s.empty?
      Transportation.all
    else
      Transportation.where("date = ?", some_date)
    end
  end
  
  def self.set_filter(date, show_all, source_storage)
	if show_all
		return Transportation.all
	end
	request_text = "date = ?"
	request_date = date
	if date.nil? or date.empty?
	  	request_text = "date >= ?"
		request_date = Date.current
	end
	if !source_storage.nil? and !source_storage.empty?
		request_text += " AND storage_source = ?"
		return Transportation.where(request_text, request_date, source_storage)
	end
	Transportation.where(request_text, request_date)
  end
	
  def self.only_active
    Transportation.where("date >= ?", Date.current)
  end
  
  def self.format_date(dd)
    if /([0-9]{2}).([0-9]{2}).([0-9]{2})/ =~ dd
      return "20"+$3+"-"+$2+"-"+$1
    end
    return dd
  end
  
  def self.load_from_file(filename, manager)
    lines = File.readlines(filename)
    for line in lines
      # Обрабатываем одну перевозку, надо найти клиента, склад
      # остальное прочто текст/число
      data_array    = line.split(";")
      client        = Client.find_by_name(data_array[2])
      dist_storage  = Storage.client_storage(client,data_array[4])
      my_storage    = data_array[5]
      
      tr            = Transportation.new
      tr.num        = data_array[3]
      tr.date       = format_date(data_array[0])
      tr.time       = data_array[16]
      tr.client     = client
      tr.storage    = dist_storage
      tr.area       = Area.find_by_name(my_storage)
      tr.weight     = data_array[6]
      tr.volume     = data_array[7]
      comment_text  = data_array[8]
      carcase       = "Термос"
      # Парсим коммент - если там есть запятая, то все что до нее в
      # тип кузова, остальное в коммент, иначе тип кузова будет тент
      if /(\W+),(\W+)\s/i =~ comment_text
        carcase   = $1.downcase
        comment   = $2
      else
        comment   = comment_text
      end
      tr.comment  = comment_text
      tr.carcase  = carcase
      tr.start_sum  = data_array[10].sub(" ", "")
      tr.step       = 500
      tr.user       = manager unless manager.nil?
      tr.save!
    end
  end
  
  def self.test_loading(filename)
    lines = File.readlines(filename)
    for line in lines
      arr = line.split(";")
    end
    return arr
  end
  
  def is_active? #заявка активна если дата заявки не меньше текущей даты!
    if self.date >= Date.current()
      return true
    end
    return false
  end
  
  def is_confirm? #заявка подтверждена, когда есть данные по машине и водителю
    if ( !self.avto_id.nil? and !self.driver_id.nil?)
      return true
    end
    return false
  end
  
  def is_busy? #заявка занята, когда есть данные по перевозчике
    return  self.company.nil? ? false : true
  end
  
  def is_today? #это сегодняшняя заявка
    return true if self.date == Date.current()
  end
  
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

  def as_xls(option = {})
      {
	"Rasp" 	=> num,
	"Date"		=> date,
	"Storage source"	=> storage_source,
	"comment"	=> comment,
	"Weigth"	=> weight,
	"carcase"	=> carcase,
	"start sum"	=> start_sum,
	"Cur sum"	=> cur_sum,
	"company"		=> company
      }
  end

  def have_spec_price?
	return  (specprice.nil? or !specprice ) ? false : true
  end

  def get_volume
      volume_text = ""
      if (self.volume == 32)
          volume_text = "32 поддона"
      elsif (self.volume == 14)
          volume_text = "14 поддонов"
      else
          volume_text = self.volume.to_s + " куб. м."
      end
      return volume_text
  end
          
end
