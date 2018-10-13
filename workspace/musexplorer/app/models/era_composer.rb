class EraComposer < ActiveRecord::Base
	belongs_to :era
	belongs_to :composer
end
