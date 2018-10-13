class FixUserTypeColumnName < ActiveRecord::Migration
  def change
  	rename_column :users, :type, :teacher
  end
end
