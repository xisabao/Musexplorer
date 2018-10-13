class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.integer :piece_id
    	t.integer :user_id
    	t.string :title, null: false
    	t.text :body

      t.timestamps null: false
    end
  end
end
