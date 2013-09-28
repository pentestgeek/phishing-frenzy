class AdminController < ApplicationController
  	#before_filter :confirm_logged_in

	def index
		list
		render('list')
	end

	def list
		@admin = Admin.sorted
	end

	def new
		@admin = Admin.new
	end

	def create
	  	@admin = Admin.new(params[:admin])
	  	if @admin.save
	  		flash[:notice] = "Admin Created"
	  		redirect_to(:action => 'list')
	  	else
	  		render('new')
	  	end
	end

	def edit
		@admin = Admin.find(params[:id])
	end

	def update
	  	@admin = Admin.find(params[:id])
	  	if @admin.update_attributes(params[:admin])
	  		flash[:notice] = "Admin Updated"
	  		redirect_to(:action => 'list')
	  	else
	  		render('edit')
	  	end
	end

	def delete
  		@admin = Admin.find(params[:id])
	end

	def destroy
	  	Admin.find(params[:id]).destroy
	  	flash[:notice] = "Admin Destroyed"
	  	redirect_to(:action => 'list')
	end

end
