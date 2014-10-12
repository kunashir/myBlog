class CreateLots < ActiveRecord::Migration
  def change
    create_table :lots do |t|
      t.string :title
      t.text :description
      t.integer :step
      t.integer :start_summa
      t.integer :current_summa
      t.date :start_date
      t.date :end_date
      t.boolean :for_selling

      t.timestamps
    end
  end
end
