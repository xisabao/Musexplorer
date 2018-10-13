class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.string :name
      t.integer :opus
      t.integer :level
      t.integer :minutes
      t.boolean :concerto
      t.boolean :solo
      t.boolean :free
      t.string :sheet_music_link
      t.text :youtube_embed
      t.integer :composer_id
      t.integer :instrument_id

      t.timestamps
    end
  end
end
