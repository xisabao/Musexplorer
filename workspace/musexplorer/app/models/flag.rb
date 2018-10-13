class Flag < ActiveRecord::Base
	belongs_to :post, polymorphic: true
	belongs_to :piece, polymorphic: true
	belongs_to :composer, polymorphic: true
	belongs_to :tip, polymorphic: true
	belongs_to :reply, polymorphic: true
	belongs_to :user
end
