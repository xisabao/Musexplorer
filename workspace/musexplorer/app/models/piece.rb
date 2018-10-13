class Piece < ActiveRecord::Base
	validates :name, presence: true
	validates :composer_id, presence: true

	belongs_to :composer
	has_many :instrument_pieces, dependent: :destroy
	has_many :instruments, through: :instrument_pieces
	has_many :posts, through: :piece_posts, dependent: :destroy
	has_many :piece_posts, dependent: :destroy
	has_many :taggings
	has_many :tags, through: :taggings
	has_many :tips
	has_many :users, through: :piece_users, dependent: :destroy
	has_many :piece_users, dependent: :destroy
	has_many :flags, as: :flaggable, dependent: :destroy

	scope :instruments, -> (instruments) { joins(:instruments).where(instruments: {id: instruments}) } #instruments is an arr
	scope :eras, -> (eras) { joins(composer: :eras).where(eras: {id: eras })} #eras is an arr
	scope :countries, -> (countries) { joins(composer: :countries).where(countries: {id: countries })} #countries is an arr
	scope :levels, -> (levels) { where(level: levels)} #levels is an arr
	scope :length, -> (min, max) { where("minutes < ?", max).where("minutes > ?", min)}
	scope :free, -> { where(free: true)}
	scope :concerto, -> { where(concerto: true)}
	scope :solo, -> { where(solo: true)}

	searchable auto_index: false do
		text :name, boost: 3
		string :name

		text :tips do
			tips.map { |tip| tip.body }
		end

		text :instruments, boost: 2 do 
			instruments.map { |instrument| instrument.name }
		end

		text :composer do
			composer.name
		end

		text :eras do
			composer.eras
		end

		text :countries do
			composer.countries
		end

		integer :opus
		integer :level
		integer :minutes
		integer :composer_id

		boolean :concerto
		boolean :solo
		boolean :free
	end

	def eras
		composer.eras
	end
	def countries
		composer.countries
	end
	def self.tag_counts
		Tag.joins(:taggings).select("tags.*, count(taggings.tag_id) as count").group("tags.id").limit(30)
	end

end
