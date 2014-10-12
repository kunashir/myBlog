class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :content
      t.date :publish_date
      t.date :end_date

      t.timestamps
    end
  end
end
