class AddShowregToUser < ActiveRecord::Migration
  def change
    add_column :users, :show_reg, :boolean, :default => true
  end
end
