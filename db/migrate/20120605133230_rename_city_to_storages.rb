class RenameCityToStorages < ActiveRecord::Migration
  def up
	remove_column(:storages, :city)
	add_column(:storages, :city_id, :integer)
  end

  def down
	
  end
end
