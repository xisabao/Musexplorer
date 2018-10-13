class DefaultsAndNonNulltoTips < ActiveRecord::Migration
  def change
  	change_column :tips, :piece_id, :integer, null: false
  	change_column :tips, :user_id, :integer, null: false
  	change_column :tips, :body, :text, null: false
  	change_column :tips, :points, :integer, null: false
  	change_column :tips, :points, :integer, default: 0
  end
end
