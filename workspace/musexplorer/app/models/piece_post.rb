class PiecePost < ActiveRecord::Base
  belongs_to :piece
  belongs_to :post
end
