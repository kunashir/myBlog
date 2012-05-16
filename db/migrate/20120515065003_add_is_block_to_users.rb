class AddIsBlockToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_block, :boolean, :default => true
  end
end
