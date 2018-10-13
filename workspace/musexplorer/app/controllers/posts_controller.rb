class PostsController < ApplicationController
	before_action :authenticate_user!, except: [:show, :search]
	before_action :correct_user, only: [:edit, :update, :destroy]
	def show
		@post = Post.find(params[:id])
		@reply = Reply.new
		@category = Category.find(params[:category_id])
		@flag = Flag.new
	end
	def new
		@post = Post.new
		@category = Category.find(params[:category_id])
	end
	def create
		@post = current_user.posts.build(title: post_params[:title], body: post_params[:body])
		# pieces = []
		# post_params[:piece_ids].each do |p_id| 
		# 	pieces << Piece.find(p_id) if !p_id.empty?
		# end
		# @post.pieces.concat(pieces)
		@category = Category.find(params[:category_id])
		@post.categories << @category
		@post.sticky = false
		if @post.save
			flash[:success] = 'Post created'
			redirect_to category_post_path(id: @post.id, category_id: @category.id)
		else
			redirect_to :back
		end
	end
	def edit
		@post = Post.find(params[:id])
		@category = Category.find(params[:category_id])
		@pieces = Piece.all
	end
	def update
		@post = Post.find(params[:id])
		@category = Category.find(params[:category_id])
		# pieces = []
		# post_params[:piece_ids].each { |p_id| pieces << Piece.find(p_id) if p_id != ""}
		# pieces.each do |p|
		# 	@post.pieces << p if !@post.pieces.include?(p)
		# end
		if @post.update_attributes(title: post_params[:title], body: post_params[:body])
			flash[:success] = "Post updated"
			redirect_to category_post_path(id: @post.id, category_id: @category.id)
		else
			render 'edit'
		end
	end
	def destroy
		Post.find(params[:id]).destroy
		flash[:success] = "Post deleted"
		redirect_to category_path(id: params[:category_id])
	end

	def vote
		@post = Post.find(params[:id])
		vote = Vote.create(votable: @post, user: current_user, vote: params[:vote])
		if vote.valid?
			flash[:success] = "Your vote was counted"
		else
			flash[:error] = "You can only vote once"
		end
		redirect_to :back
	end

	def search
		@search = Post.search do
			keywords search_params[:keywords], fields: [:title, :body, :replies, :user]

			order_by :score, :desc
		end
		render 'search_results'
	end

	private
	def search_params
		params.permit(:keywords)
	end
	def post_params
		params.require(:post).permit(:title, :body, :piece_ids => [])
	end
	def correct_user
		@post = current_user.posts.find_by(id: params[:id])
		redirect_to root_url if @post.nil?
	end
end
