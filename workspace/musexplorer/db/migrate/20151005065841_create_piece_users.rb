class CreatePieceUsers < ActiveRecord::Migration
  def change
    create_table :piece_users do |t|
    	t.references :piece, index: true, foreign_key: true
    	t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
