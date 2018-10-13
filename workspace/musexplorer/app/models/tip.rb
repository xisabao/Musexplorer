class Tip < ActiveRecord::Base
	belongs_to :piece
	belongs_to :user
	has_many :votes, as: :votable
	has_many :flags, as: :flaggable, dependent: :destroy


	validates :piece_id, presence: true
	validates :user_id, presence: true
	validates :body, presence: true

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
