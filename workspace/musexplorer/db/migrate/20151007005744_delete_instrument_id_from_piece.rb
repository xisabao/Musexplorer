class DeleteInstrumentIdFromPiece < ActiveRecord::Migration
  def change
  	remove_column :pieces, :instrument_id
  end
end
