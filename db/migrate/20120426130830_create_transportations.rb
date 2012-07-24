class CreateTransportations < ActiveRecord::Migration
  def change
    create_table :transportations do |t|
      t.integer :num
      t.date :date
      t.time :time
      t.string :storage_source
      t.string :storage_dist
      t.string :comment
      t.string :type_transp
      t.decimal :weight
      t.string :carcase
      t.integer :start_sum
      t.integer :cur_sum
      t.integer :step
      t.integer :user_id
      t.integer :carrier_id

      t.timestamps
    end
    add_index :transportations, :date
  end

end
