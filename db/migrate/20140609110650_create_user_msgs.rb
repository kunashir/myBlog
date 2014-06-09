class CreateUserMsgs < ActiveRecord::Migration
  def change
    create_table :user_msgs do |t|
      t.boolean :active, :default => true
      t.belongs_to :user
      t.belongs_to :message
      t.timestamps
    end
  end
end
