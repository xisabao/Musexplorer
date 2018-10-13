class Vote < ActiveRecord::Base
	belongs_to :user
	belongs_to :votable, polymorphic: true

	validates_uniqueness_of :user, scope: [:votable_type, :votable_id]
end
