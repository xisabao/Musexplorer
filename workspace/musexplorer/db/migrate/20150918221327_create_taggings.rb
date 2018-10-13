class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :tag, index: true, foreign_key: true, null: false
      t.belongs_to :piece, index: true, foreign_key: true, null: false
      t.integer :votes, default: 0

      t.timestamps null: false
    end
    change_column :tags, :name, :string, null: false
  end
end
