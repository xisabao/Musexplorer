class CreateEraComposers < ActiveRecord::Migration
  def change
    create_table :era_composers do |t|
      t.integer :era_id
      t.integer :composer_id

      t.timestamps null: false
    end
  end
end
