class RemoveVotesFromTaggingsAndPointsFromTips < ActiveRecord::Migration
  def change
  	remove_column :taggings, :votes
  	remove_column :tips, :points
  end
end
