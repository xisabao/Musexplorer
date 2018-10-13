class RepliesController < ApplicationController
	before_action :authenticate_user!
	before_action :correct_user, only: [:update, :destoy]

	def create
		@reply = current_user.replies.build(reply_params)
		@reply.post_id = params[:post_id]
		if @reply.save
			flash[:success] = "Reply created"
			redirect_to category_post_path(category_id: params[:category_id], id: params[:post_id])
		else
			redirect_to category_post_path(category_id: params[:category_id], id: params[:post_id])
		end
	end
	def update
		@reply = Reply.find(params[:id])
		if @reply.update_attributes(reply_params)
			flash[:success] = "Reply updated"
			redirect_to category_post_path(category_id: params[:category_id], id: params[:post_id])
		else
			redirect_to category_post_path(category_id: params[:category_id], id: params[:post_id])
		end
	end
	def destroy
		@reply = Reply.find(params[:id]).destroy
		flash[:success] = "Reply deleted"
		redirect_to :back
	end
	
	def vote
		@reply = Reply.find(params[:id])
		vote = Vote.create(votable: @reply, user: current_user, vote: params[:vote])
		if vote.valid?
			flash[:success] = "Your vote was counted"
		else
			flash[:error] = "You can only vote once"
		end
		redirect_to :back
	end

	private
	def reply_params
		params.require(:reply).permit(:body)
	end

	def correct_user
		@reply = current_user.replies.find_by(id: params[:id])
		redirect_to root_url if @reply.nil?
	end
end
