class AddManagerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nmanager, :boolean
  end
end
