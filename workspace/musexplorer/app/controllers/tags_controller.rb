class TagsController < ApplicationController
	def index
		@tags = Tag.all
	end
	def show
		@tag = Tag.find(params[:id])
		@taggings = Tagging.where(tag_id: @tag.id).sort_by { |t| t.total_votes }.reverse
	end
	def new
		@piece = Piece.find(params[:id])
		@tag = Tag.find_or_create_by(name: new_tag_params[:name])
		@tagging = Tagging.find_or_create_by(piece_id: params[:id], tag_id: @tag.id)
		flash[:success] = "Tag added"
		redirect_to @piece
	end

	private
	def new_tag_params
		params.permit(:name)
	end
end
