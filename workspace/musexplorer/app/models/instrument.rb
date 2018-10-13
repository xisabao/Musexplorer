class Instrument < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true

	has_many :pieces, through: :instrument_pieces
	has_many :instrument_pieces, dependent: :destroy

	def names_for_select
		name.capitalize
	end
end
