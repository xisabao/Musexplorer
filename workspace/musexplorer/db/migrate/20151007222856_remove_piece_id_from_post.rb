class RemovePieceIdFromPost < ActiveRecord::Migration
  def change
  	remove_column :posts, :piece_id
  end
end
