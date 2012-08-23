class AddTransportationTimelastaction < ActiveRecord::Migration
  def up
  	add_column	:transportations, :time_last_action, :datetime
  end

  def down
  	remove_column	:transportations, :time_last_action
  end
end
