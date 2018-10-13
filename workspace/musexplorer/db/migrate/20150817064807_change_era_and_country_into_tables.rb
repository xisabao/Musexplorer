class ChangeEraAndCountryIntoTables < ActiveRecord::Migration
  def change
  	remove_column :composers, :country, :string
  	remove_column :composers, :era, :string
  end
end
