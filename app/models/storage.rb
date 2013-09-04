class Storage < ActiveRecord::Base
  belongs_to  :client
	belongs_to	:city
  
  before_save :set_name

# найти склады клиента по наименованию склада
  def self.client_storage(client, storage_name)
    where("(client_id = ?) AND (name LIKE ?)", client, "#{storage_name}%").first
  end
  
private

  def set_name
    self.name ||= city.name
  end
end
