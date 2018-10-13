class RenameInstrumentNamesToName < ActiveRecord::Migration
  def change
  	rename_column :instruments, :names, :name
  end
end
