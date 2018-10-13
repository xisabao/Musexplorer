class Reply < ActiveRecord::Base
	belongs_to :post
	belongs_to :user
	has_many :votes, as: :votable
	has_many :flags, as: :flaggable, dependent: :destroy


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
