class Composer < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true

	has_many :pieces

	has_many :country_composers
	has_many :countries, through: :country_composers

	has_many :era_composers
	has_many :eras, through: :era_composers
	has_many :flags, as: :flaggable, dependent: :destroy

end
