class Client < ActiveRecord::Base
  attr_accessible :name
  has_many  :storages
  
  validates :name, :presence  => true

  def storages
    Storage.where("client_id=?", self)
  end
end
