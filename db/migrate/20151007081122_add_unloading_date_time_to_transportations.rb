class AddUnloadingDateTimeToTransportations < ActiveRecord::Migration
  def change
    add_column :transportations, :unloading, :datetime
  end
end
