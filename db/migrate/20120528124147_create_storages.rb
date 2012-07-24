class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.string :city
      t.string :address
      t.integer :client_id

      t.timestamps
    end
  end
end
