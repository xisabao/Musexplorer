class CreateCountryComposers < ActiveRecord::Migration
  def change
    create_table :country_composers do |t|
      t.integer :country_id
      t.integer :composer_id

      t.timestamps null: false
    end
  end
end
