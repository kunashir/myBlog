class CreateAvtos < ActiveRecord::Migration
  def change
    create_table :avtos do |t|
      t.string :model
      t.string :carcase
      t.string :statenumber
      t.string :trailnumber
      t.integer :company_id

      t.timestamps
    end
  end
end
