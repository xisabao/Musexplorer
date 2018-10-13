class CreateEras < ActiveRecord::Migration
  def change
    create_table :eras do |t|
      t.string :name

      t.timestamps
    end
  end
end
