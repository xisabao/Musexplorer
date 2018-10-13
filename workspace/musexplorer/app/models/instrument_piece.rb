class InstrumentPiece < ActiveRecord::Base
	belongs_to :instrument 
	belongs_to :piece
end
