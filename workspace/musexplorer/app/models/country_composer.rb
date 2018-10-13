class CountryComposer < ActiveRecord::Base
	belongs_to :country
	belongs_to :composer
end
