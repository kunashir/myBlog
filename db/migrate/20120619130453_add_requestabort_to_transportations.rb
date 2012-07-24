class AddRequestabortToTransportations < ActiveRecord::Migration
  def change
    add_column :transportations, :request_abort, :boolean, :default => false
  end
end
