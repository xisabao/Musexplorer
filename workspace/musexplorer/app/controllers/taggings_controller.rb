class TaggingsController < ApplicationController
	before_action :authenticate_user!
	def vote
		@tagging = Tagging.find(params[:id])
		vote = Vote.create(votable: @tagging, user: current_user, vote: params[:vote])
		if vote.valid?
			flash[:success] = "Your vote was counted"
		else
			flash[:error] = "You can only vote once"
		end
		redirect_to :back
	end
end
