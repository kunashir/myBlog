class Transportation < ActiveRecord::Base
  attr_accessible  :num, :date, :time, :storage_source, :storage_dist, :comment, :type_transp, :weight, :carcase, :start_sum, :cur_sum, :step, :company, :volume
  
  belongs_to :user
  belongs_to :company
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
end
