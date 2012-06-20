class AddShortnameToAvtos < ActiveRecord::Migration
  def change
    add_column :avtos, :shortname, :string
  end
end
