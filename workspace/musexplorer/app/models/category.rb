class Category < ActiveRecord::Base
	has_many :category_posts, dependent: :destroy
	has_many :posts, through: :category_posts, dependent: :destroy

	validates :name, presence: true, uniqueness: true
end
