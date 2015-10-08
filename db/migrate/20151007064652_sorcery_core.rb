class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,            :null => false
      t.string :crypted_password
      t.string :salt
      t.boolean :admin
      t.boolean :manager
      t.references :company
      t.boolean :is_block, default: true
      t.boolean :be_notified, default: true
      t.boolean :show_reg, default: false
      t.string :name

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end