class Era < ActiveRecord::Base
	has_many :era_composers
	has_many :composers, through: :era_composers

	validates :name, presence: true, uniqueness: true

	def self.all_eras
		Era.order('name ASC').distinct.pluck(:name)
	end
end
