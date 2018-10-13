class TipsController < ApplicationController
	before_action :authenticate_user!
	before_action :correct_user, only: [:destroy]

	def create
		@piece = Piece.find(tip_params[:piece_id])
		@tip = current_user.tips.build(tip_params)
		if @tip.save
			flash[:success] = 'Tip added!'
			redirect_to @piece
		else
			render @piece
		end
	end
	def destroy
		Tip.find(params[:id]).destroy
		flash[:success] = "Tip deleted"
		redirect_to :back
	end

	def vote
		@tip = Tip.find(params[:id])
		vote = Vote.create(votable: @tip, user: current_user, vote: params[:vote])
		if vote.valid?
			flash[:success] = "Your vote was counted"
		else
			flash[:error] = "You can only vote once"
		end
		redirect_to :back
	end

	private
	def tip_params
		params.require(:tip).permit(:body, :piece_id)
	end
	def correct_user
		@tip = current_user.tips.find_by(id: params[:id])
		redirect_to root_url if @tip.nil?
	end
end
