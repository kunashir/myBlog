class AddComplexDirectionToTransportations < ActiveRecord::Migration
  def change
    add_column :transportations, :complex_direction, :boolean
    add_column :transportations, :extra_pay, :integer, :default => 0
  end
end
