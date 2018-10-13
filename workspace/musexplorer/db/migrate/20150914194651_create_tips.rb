class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.integer :piece_id
      t.integer :user_id
      t.text :body
      t.integer :points

      t.timestamps null: false
    end
  end
end
