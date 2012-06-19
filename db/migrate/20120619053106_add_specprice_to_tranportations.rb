class AddSpecpriceToTranportations < ActiveRecord::Migration
  def change
    add_column :transportations, :specprice, :boolean
  end
end
