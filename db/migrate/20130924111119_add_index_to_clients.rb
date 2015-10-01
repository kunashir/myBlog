class AddIndexToClients < ActiveRecord::Migration
  def change
    add_index :storages, :id
    add_index :clients, :id
  end
end
