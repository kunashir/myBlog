class AddStorageToTransportations < ActiveRecord::Migration
  def change
    add_column :transportations, :storage_id, :integer
  end
end
