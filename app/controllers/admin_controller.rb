class AdminController < ApplicationController

	def index
		list
		render('list')
	end

	def list
		if params[:approved] == "false"
			@admins = Admin.where(approved: false)
		else
			@admins = Admin.all
		end
	end

	def logins
		@admin = Admin.find(params[:id])
		@logins = @admin.versions.map{|version| version.reify}
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

	def global_settings
		@global_settings = GlobalSettings.first
	end

	def update_global_settings
		@global_settings = GlobalSettings.first
		if @global_settings.update_attributes(params[:global_settings])
			flash[:notice] = "Settings Updated"
			redirect_to(:action => 'global_settings')
		else
			render('global_settings')		
		end
	end

	def approve
		@admin = Admin.find(params[:id])
		@admin.approved = true
		@admin.save
		redirect_to(:action => 'list')
	end

	def revoke
		@admin = Admin.find(params[:id])
		@admin.approved = false
		@admin.save
		redirect_to(:action => 'list')
	end

end
