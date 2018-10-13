class PieceUser < ActiveRecord::Base
	belongs_to :piece
	belongs_to :user
end
