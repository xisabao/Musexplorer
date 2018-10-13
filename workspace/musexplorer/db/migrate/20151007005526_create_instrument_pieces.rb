class CreateInstrumentPieces < ActiveRecord::Migration
  def change
    create_table :instrument_pieces do |t|
    	t.references :instrument, index: true, foreign_key: true
    	t.references :piece, index: true, foreign_key: true

    	t.timestamps null: false
    end
  end
end
