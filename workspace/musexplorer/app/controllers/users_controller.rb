class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
	end
	def edit
		@user = User.find(params[:id])
	end
	def update
		@user = User.find(params[:id])
		@user.update_attributes(description: user_params[:description], location: user_params[:location])
		@user.teacher = user_params[:teacher]
		if @user.save
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end

	private
	def user_params
		params.require(:user).permit(:teacher, :description, :location)
	end
end
