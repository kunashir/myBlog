class AddCityToTransportaions < ActiveRecord::Migration
  def change
    change_table :transportations do |t|
      t.references :city, :index => true
    end
  end
end
