class AddNotNullConstraints < ActiveRecord::Migration
  def change
  	change_column :composers, :name, :string, null: false
  	change_column :composers, :country, :string, null: false
  	change_column :composers, :era, :string, null: false
  	change_column :instruments, :names, :string, null: false
  	change_column :pieces, :name, :string, null: false
  	change_column :pieces, :composer_id, :integer, null: false
  	change_column :pieces, :instrument_id, :integer, null: false
  end
end
