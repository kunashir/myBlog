class AddNameToStorages < ActiveRecord::Migration
  def change
    add_column :storages, :name, :string
  end
end
