class ItemsController < ApplicationController
	before_action :find_item, only: [:show,:edit,:update,:destroy]
	before_action :is_item_for_current_user?, only: [:show,:edit,:update,:destroy]
	def index
		if user_signed_in?
			@items = Item.where(:user_id => current_user.id).order("created_at DESC")
		end
	end

	def show
		redirect_to root_path unless @item
		redirect_to root_path unless @flag
	end

	def new
		@item = current_user.items.build
	end

	def create
		@item = current_user.items.build(item_params)
		if @item.save
			redirect_to root_path
		else
			render 'new'
		end
	end

	def edit
		redirect_to root_path unless @flag
	end

	def update
		if !@flag 
			redirect_to root_path
		elsif @item.update(item_params)
			redirect_to item_path(@item)
		else
			render 'edit'
		end
	end

	def destroy
		unless @flag
			redirect_to root_path
		else
			@item.destroy
			redirect_to root_path
		end
	end

	def complete
		@item = Item.find(params[:id])
		@item.update_attribute(:completed_at, Time.now)
		redirect_to root_path
	end

	private
		def item_params
			params.require(:item).permit(:title, :description)
		end

		def find_item
			@item = Item.find_by_id(params[:id])
		end

		def is_item_for_current_user?
			find_item
			unless @item.user_id == current_user.id
				@flag = false 
			else
				@flag = true
			end
		end
end
