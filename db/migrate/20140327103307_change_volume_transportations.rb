class ChangeVolumeTransportations < ActiveRecord::Migration
  def up
    change_column :transportations, :volume, :string
  end

  def down
    change_column :transportations, :volume, :decimal
  end
end
