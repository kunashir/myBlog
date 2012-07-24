class AddAreaToTransportation < ActiveRecord::Migration
  def change
    add_column :transportations, :area_id, :integer
  end
end
