class Country < ActiveRecord::Base
	has_many :country_composers
	has_many :composers, through: :country_composers

	validates :name, presence: true, uniqueness: true

	def self.all_countries
		Country.order('name ASC').distinct.pluck(:name)
	end
end
