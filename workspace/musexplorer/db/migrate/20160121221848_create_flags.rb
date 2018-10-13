class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
    	t.integer :user_id
    	t.text :description
    	t.string :reason
    	t.references :flaggable, polymorphic: true

    	t.timestamps
    end
  end
end
