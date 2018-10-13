class FlagsController < ApplicationController
	before_filter :find_flaggable, :authenticate_user!

	def create
		@flag = @flaggable.flags.build(description: flag_params[:flag][:description], reason: flag_params[:flag][:reason])
		@flag.user = current_user
		if @flag.save
			respond_to do |format|
				format.js { render json: nil, status: :ok}
				format.html { redirect_to :back }
			end
		end
	end

	private
	def flag_params
		params.permit(:flaggable_id, :flaggable_type, flag: [:reason, :description])
	end
	def find_flaggable
		@flaggable_type = flag_params[:flaggable_type].capitalize.constantize
		@flaggable = @flaggable_type.find(flag_params[:flaggable_id])
	end
end
