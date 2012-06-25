class AddAbortcompanyToTransportations < ActiveRecord::Migration
  def change
    add_column :transportations, :abort_company, :integer
  end
end
