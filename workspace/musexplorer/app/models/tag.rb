class Tag < ActiveRecord::Base
	has_many :taggings
	has_many :pieces, through: :taggings

	validates :name, presence: true, uniqueness: true

	def names_for_select
		name.capitalize
	end
end
