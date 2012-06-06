class Storage < ActiveRecord::Base
  belongs_to  :client
	belongs_to	:city
  
  before_save :set_name
  
  
private

  def set_name
    if self.name.nil?
      self.name = city.name
    end
  end
end
