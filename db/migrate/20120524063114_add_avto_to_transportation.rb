class AddAvtoToTransportation < ActiveRecord::Migration
  def change
    add_column :transportations, :avto_id, :integer
  end
end
