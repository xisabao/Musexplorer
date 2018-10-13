class Post < ActiveRecord::Base
	has_many :replies, dependent: :destroy
	has_many :votes, as: :votable
	has_many :category_posts, dependent: :destroy
	has_many :categories, through: :category_posts
	belongs_to :user
	has_many :pieces, through: :piece_posts
	has_many :piece_posts, dependent: :destroy
	has_many :flags, as: :flaggable, dependent: :destroy

	validates :title, presence: true

	searchable do
		text :title, :body

		text :replies do
			replies.map { |reply| reply.body }
		end

		text :user do
			user.username
		end

		integer :user_id
	end

	def total_votes
		self.up_votes - self.down_votes
	end
	def up_votes
		self.votes.where(vote: true).size
	end
	def down_votes
		self.votes.where(vote: false).size
	end
	def timestamp
		r = self.replies.order(:updated_at).last
			if r && r.updated_at > self.updated_at
				return r.updated_at
			end
		return self.updated_at
	end
end
