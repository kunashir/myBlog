class RenameActiveToCities < ActiveRecord::Migration
  def up
    change_table :cities do |t|
      t.rename :acive, :active
    end
  end

  def down
    change_table :cities do |t|
      t.rename :active, :acive
    end
  end
end
