require 'kaminari'
class PiecesController < ApplicationController
	before_action :authenticate_user!, only: [:add_piece_user, :delete_piece_user]
	before_action :correct_user, only: [:add_piece_user, :delete_piece_user]
	def index
		@instruments = Instrument.all.order('name ASC')
		@eras = Era.all.order('name ASC')
		@countries = Country.all.order('name ASC')
		if find_params[:keywords]
			@search = Piece.search do
				keywords find_params[:keywords], fields: [:name, :instruments, :composer, :eras, :countries]
				
				order_by :score, :desc
			end
		else
			@pieces = Piece.where(nil)
			@pieces = @pieces.instruments(filter_params[:instruments]) if filter_params[:instruments]
			@pieces = @pieces.eras(filter_params[:eras]) if filter_params[:eras]
			@pieces = @pieces.countries(filter_params[:countries]) if filter_params[:countries]	
			@pieces = @pieces.levels(filter_params[:level_list]) if filter_params[:level_list]
			@pieces = @pieces.length(filter_params[:minutes][:min], filter_params[:minutes][:max]) if filter_params[:minutes] && filter_params[:minutes].values.none? { |v| v == "" }
			@pieces = @pieces.free if filter_params[:free]
			@pieces = @pieces.concerto if filter_params[:concerto]
			@pieces = @pieces.solo if filter_params[:solo]
			@pieces = Kaminari.paginate_array(@pieces).page(filter_params[:page])
		end
	end

	def add_piece_user
		@piece = Piece.find(params[:piece_id])
		current_user.pieces << @piece
		current_user.save
		flash[:success] = "Piece added to history"
		redirect_to @piece
	end

	def delete_piece_user
		@piece = Piece.find(params[:piece_id])
		current_user.pieces.delete(@piece)
		flash[:success] = "Piece deleted from history"
		redirect_to @piece
	end

	def search
		@instruments = Instrument.order(:name)
		@tags = Piece.tag_counts
	end

	def search_results
		if search_params[:instruments]
			@results = {}
			# queries = []
			# query = Piece.joins(:instruments)   
			# search_params[:instruments].each do |instrument|
			#   queries << query.where(instruments: {id: instrument})
			# end
			# sql_str = ""
			# queries.each_with_index do |query, i|
			# 	sql_str += "#{query.to_sql}"
			# 	sql_str += " INTERSECT " if i != queries.length - 1
			# end

			# Piece.find_by_sql(sql_str).each do |p|
			#literally fuck this, won't work for more than 2   
			query = Piece.joins(:instruments).where(instruments: {id: search_params[:instruments]})
			query = query.joins(:tags).where(tags: {id: search_params[:tags]}) if search_params[:tags] && !search_params[:tags].empty?
			user_level = nil
			user_level = current_user.average_level(search_params[:instruments]) if user_signed_in? && search_params[:piece_history] && search_params[:piece_history] == "1"
			query.find_each(batch_size: 20) do |p|
				if user_signed_in? && !current_user.pieces.include?(p)
					@results = pointser(search_params, p, @results, user_level) 
				else
					@results = pointser(search_params, p, @results, user_level) 
				end
			end
			@results = @results.sort_by { |piece, points| points }.reverse.to_h
		end
	end

	def show
		@piece = Piece.find(params[:id])
		@taggings = @piece.taggings.sort_by {|tagging| tagging.total_votes }.reverse
		@tips = @piece.tips.sort_by {|tip| tip.total_votes }.reverse
		@tip = Tip.new
		@flag = Flag.new
	end

	private
	def pointser(search_params, p, hash, user_level)
		points = 0
		total = 0
		if search_params[:levels].values.none? { |v| v == "" } && p.level && !user_level
			total += 10
			if search_params[:levels][:min].to_i <= p.level && search_params[:levels][:max].to_i >= p.level
				points += 10
			else
				if (sm = (search_params[:levels][:min].to_i - p.level).abs) < (lg = (search_params[:levels][:max].to_i - p.level).abs)
					points += sm
				else
					points += lg
				end
			end
		end
		if user_level && p.level
			total += 10
			if (dlvl = (user_level - p.level).abs)
				points += (10 - dlvl)
			end
		end
		if search_params[:eras] && !search_params[:eras].empty? && p.eras.any?
			total += 10
			points += 10 if intersect(search_params[:eras], p.eras.map { |e| e.name })
		end
		if search_params[:countries] && !search_params[:countries].empty? && p.countries.any?
			total += 10
			points += 10 if intersect(search_params[:countries], p.countries.map { |c| c.name })
		end
		if search_params[:minutes].values.none? { |v| v == "" } && p.minutes
			total += 10
			if (min = search_params[:minutes][:min].to_i) <= p.minutes && p.minutes <= (max = search_params[:minutes][:max].to_i)
				points += 10
			end
		end
		if search_params[:concerto] && search_params[:concerto] == "1" && p.concerto != nil
			total += 10
			if p.concerto
				points += 10 
				
			end
		end
		# if search_params[:solo] && p.solo
		# 	total += 10
		# 	if p.solo
		# 		points += 10
		# 	end
		# end
		if search_params[:free] && search_params[:free] == "1" && p.free != nil
			total += 10
			if p.free
				points += 10
			end
		end
		score = points.to_f/total.to_f * 100 if total != 0
		score = 100.0 if total == 0
		hash[p] = score if score > 20.0
		return hash
	end
	def find_params
		params.permit(:keywords)
	end
	def filter_params
		params.permit(:page, :concerto, :solo, :free, :piece_history, :instruments => [], :tags => [],  :level_list => [], :eras => [], :countries => [], :minutes => [:min, :max])
	end
	def search_params
		params.permit(:page, :concerto, :solo, :free, :piece_history, :instruments => [], :tags => [],  :level_list => [], :eras => [], :countries => [], :levels => [:min, :max], :minutes => [:min, :max])
	end
	def intersect(arr1, arr2)
		res = arr1 & arr2
		return false if res.empty?
		return true
	end
	def correct_user
		current_user == User.find(params[:user_id])
	end
end
