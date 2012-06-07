#coding: utf-8
class Transportation < ActiveRecord::Base
  attr_accessible  :num, :date, :time, :storage_source, :storage_dist, :comment, :type_transp, :weight, :carcase, :start_sum, :cur_sum, :step, :company, :volume, :client_id, :storage_id
  
  belongs_to  :user
  belongs_to  :company
  belongs_to  :avto
  belongs_to  :driver
  belongs_to  :client
  belongs_to  :storage
  
  #validates :user_id, :presence => true
  validates :date,            :presence => true
  validates :time,            :presence => true
  validates :storage_source,  :presence => true
  # validates :storage_dist,    :presence => true
  # validates :type_transp,     :presence => true
  validates :weight,          :presence => true
  validates :carcase,         :presence => true
  validates :start_sum,       :presence => true
  validates :step,            :presence => true
  default_scope               :order  =>  'transportations.date DESC' #показываем самые свежие
  
  def self.transportation_for_date(some_date)
    if some_date.to_s.empty?
      Transportation.all
    else
      Transportation.where("date = ?", some_date)
    end
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
      data_array    = line.split("#")
      client        = Client.find_by_name(data_array[2])
      dist_storage  = Storage.client_storage(client,data_array[4])
      my_storage    = data_array[5]
      
      tr            = Transportation.new
      tr.num        = data_array[3]
      tr.date       = format_date(data_array[0])
      tr.time       = data_array[16]
      tr.client     = client
      tr.storage    = dist_storage
      tr.storage_source = my_storage
      tr.weight     = data_array[6]
      tr.volume     = data_array[7]
      comment_text  = data_array[8]
      carcase       = "Тент"
      # Парсим коммент - если там есть запятая, то все что до нее в
      # тип кузова, остальное в коммент, иначе тип кузова будет тент
      if /(\W+),(\W+)\s/ =~ comment_text
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
      arr = line.split("#")
    end
    return arr
  end
  
  def is_active?
    if ( self.avto_id.nil? or self.driver_id.nil?)
      return true
    end
    return false
  end
end
