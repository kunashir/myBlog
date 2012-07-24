class AddClientToTransportations < ActiveRecord::Migration
  def change
    add_column :transportations, :client_id, :integer
  end
end
