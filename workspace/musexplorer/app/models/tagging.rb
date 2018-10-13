class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :piece
  has_many :votes, as: :votable

  	def total_votes
		self.up_votes - self.down_votes
	end
	def up_votes
		self.votes.where(vote: true).size
	end
	def down_votes
		self.votes.where(vote: false).size
	end
end
