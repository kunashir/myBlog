class AddIndexToTransportations < ActiveRecord::Migration
  def change
    add_index :transportations, :id
  end
end
