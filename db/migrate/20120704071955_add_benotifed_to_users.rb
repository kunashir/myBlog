class AddBenotifedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :be_notified, :boolean, :default => true
  end
end
