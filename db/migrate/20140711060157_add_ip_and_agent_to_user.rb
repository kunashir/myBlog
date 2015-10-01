class AddIpAndAgentToUser < ActiveRecord::Migration
  def change
    add_column :users, :ip, :string
    add_column :users, :agent, :string
  end
end
