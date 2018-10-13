class AddMoreNotNullConstraints < ActiveRecord::Migration
  def change
  	change_column :users, :username, :string, null: false
  	change_column :users, :role, :integer, default: 0
  	change_column :countries, :name, :string, null: false
  	change_column :eras, :name, :string, null: false
  end
end
