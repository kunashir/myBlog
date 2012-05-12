class AddCompanyToTransportations < ActiveRecord::Migration
  def change
    add_column :transportations, :company_id, :integer
  end
end
