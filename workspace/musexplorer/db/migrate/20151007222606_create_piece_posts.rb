class CreatePiecePosts < ActiveRecord::Migration
  def change
    create_table :piece_posts do |t|
      t.references :piece, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
