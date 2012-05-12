class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :inn
      t.boolean :is_freighter

      t.timestamps
    end
  end
end
