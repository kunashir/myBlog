class AddRateToTransportation < ActiveRecord::Migration
  def change
    add_column :transportations, :rate_id, :integer
  end
end
