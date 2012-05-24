class AddDriverToTransportation < ActiveRecord::Migration
  def change
    add_column :transportations, :driver_id, :integer
  end
end
