class CategoriesController < ApplicationController
	def index
		@categories = Category.all
	end
	def show
		@category = Category.find(order_params[:id])
		@stickies = @category.posts.where(sticky: true)
		@posts = @category.posts.where(sticky: false).sort_by { |p| p.timestamp }.reverse if !order_params[:order] || order_params[:order] == "Most Recent"
		@posts = @category.posts.where(sticky: false).sort_by { |p| p.total_votes }.reverse if order_params[:order] == "Most Popular"
	end

	private
	def order_params
		params.permit(:order, :id)
	end
end
