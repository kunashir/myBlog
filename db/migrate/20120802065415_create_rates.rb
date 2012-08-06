class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.integer :area_id
      t.integer :city_id
      t.string :carcase
      t.integer :summa

      t.timestamps
    end
  end
end
