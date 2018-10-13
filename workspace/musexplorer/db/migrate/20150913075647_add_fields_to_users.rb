class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :username, :string
  	add_column :users, :karma, :integer
  	add_column :users, :role, :integer
  	add_column :users, :type, :integer
  	add_column :users, :description, :text
  end
end
