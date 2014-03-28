class AddActiveToCities < ActiveRecord::Migration
  def change
    change_table :cities do |t|
      t.boolean :acive, :default => false
    end
  end
end
