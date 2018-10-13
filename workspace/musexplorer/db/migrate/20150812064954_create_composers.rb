class CreateComposers < ActiveRecord::Migration
  def change
    create_table :composers do |t|
      t.string :name
      t.string :country
      t.string :era
      t.text :description
      t.string :wikipedia_link
      
      t.timestamps
    end
  end
end
