class Transportation < ActiveRecord::Base
  attr_accessible  :num, :date, :time, :storage_source, :storage_dist, :comment, :type_transp, :weight, :carcase, :start_sum, :cur_sum, :step, :company, :volume
  
  belongs_to :user
  belongs_to :company
  belongs_to :avto
  belongs_to :driver
  #validates :user_id, :presence => true
  validates :date,    :presence => true
  validates :time,    :presence => true
  validates :storage_source, :presence => true
  validates :storage_dist, :presence => true
  validates :type_transp, :presence => true
  validates :weight, :presence => true
  validates :carcase, :presence => true
  validates :start_sum, :presence => true
  validates :step, :presence => true
  default_scope :order  =>  'transportations.date DESC' #показываем самые свежие
  
  def self.transportation_for_date(some_date)
    if some_date.to_s.empty?
      Transportation.all
    else
      Transportation.where("date = ?", some_date)
    end
  end
end
