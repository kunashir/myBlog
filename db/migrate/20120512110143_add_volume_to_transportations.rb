class AddVolumeToTransportations < ActiveRecord::Migration
  def change
    add_column :transportations, :volume, :decimal
  end
end
