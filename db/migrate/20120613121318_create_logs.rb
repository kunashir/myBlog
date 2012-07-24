class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :transportation_id
      t.integer :user_id
      t.string  :attr
      t.string  :oldvalue
      t.string  :action

      t.timestamps
    end
  end
end
