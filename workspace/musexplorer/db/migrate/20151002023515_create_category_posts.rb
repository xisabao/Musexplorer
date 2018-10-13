class CreateCategoryPosts < ActiveRecord::Migration
  def change
    create_table :category_posts do |t|
      t.references :category, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
