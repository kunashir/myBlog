class Client < ActiveRecord::Base
  attr_accessible :name, :city, :client
  has_many  :storages
  has_many  :transportations
  
  validates :name, :presence  => true
	default_scope	:order => 'clients.name  ASC'
  
  def storages
    Storage.where("client_id = ?", self)
  end
  
  def self.add_storages(client, storages_arr)
    print(client)
    storages_arr.each do |storage|
      st = Storage.where("(client_id = ?) and (name Like ?)", client, "#{storage}%").first
      if st.nil?
        st = Storage.new do |s|
          s.client  = Client.find(client)
          city    = City.where("name LIKE ?", "#{storage}%").first
          if city.nil?
            city  = City.new(:name => storage)
            city.save!
          end
          s.city = city
        end
        st.save!
      end
    end
  end
  
  
  
  def self.load_from_file(filename)
    lines = File.readlines(filename)
    m_hash = Hash.new
    lines.each do |line|
      /(\W+),(\W+)\s/ =~ line
      client_name  = $1
      city_storage = $2
      if !client_name.blank? 
        if m_hash.has_key?(client_name)
          m_hash[client_name][m_hash[client_name].count] = city_storage
        else
          m_hash[client_name] = Array.new(1, city_storage)
        end
      end
    end
    
    m_hash.keys.each do |key|
      client = Client.where("name = ?", key)
      if (client.empty?) #create client
        client = Client.new(:name => key)
        client.save!
      end
      add_storages(client, m_hash[key])
    end
  end
  
  
end
