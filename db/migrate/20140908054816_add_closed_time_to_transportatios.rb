class AddClosedTimeToTransportatios < ActiveRecord::Migration
  def change
    add_column :transportations, :last_bid_at, :datetime
  end
end
