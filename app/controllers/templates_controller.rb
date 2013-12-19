class TemplatesController < ApplicationController

	def index
		list
		render('list')
	end

	def list
		@templates = Template.order("id").page(params[:page] || 1).per(8)
	end

	def show
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			list
			render('list')
		end

		@images = @template.images

		# determine if location exists
		if File.directory? File.join(Rails.root.to_s, 'public', 'templates', @template.location)
			@template_exists = true
		else
			@template_exists = false
		end
	end

	def new
		@template = Template.new
	end

	def create
		@template = Template.new(params[:template])

		if not @template.valid?
			render('new')
			return
		end

		if @template.save
			flash[:notice] = "Template Created"
			redirect_to(:action => 'list')
		else
			flash[:notice] = "Problem Saving Template"
			redirect_to(:action => 'new')
		end
	end

	def edit
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			list
			render('list')
		end

		# list of template files
		template_www_location = File.join(Rails.root.to_s, 'public', 'templates', @template.location, 'www', '**')
		@template_files = Dir["#{template_www_location}"]
		template_email_location = File.join(Rails.root.to_s, 'public', 'templates', @template.location, 'email', '**')
		@email_files= Dir["#{template_email_location}"]
	end

	def update
		@template = Template.find(params[:id])

		if not @template.valid?
			render('edit')
			return
		end

		if @template.location != params[:template][:location]
			FileUtils.mv(File.join(Rails.root.to_s, 'public', 'templates', @template.location), File.join(Rails.root.to_s, 'public', 'templates', params[:template][:location]))
		end

		if @template.update_attributes(params[:template])
			flash[:notice] = "Template Updated"
			redirect_to(:action => 'list')
		else
			render('edit')
		end
	end

	def delete
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			list
			render('list')
		end
	end

	def destroy
		# delete folder if_exists?
		@template = Template.find_by_id(params[:id])

		if folder_exists?(@template.location)
			FileUtils.rm_rf(File.join(Rails.root.to_s, 'public', 'templates', @template.location))
		end

		Template.find(params[:id]).destroy
		flash[:notice] = "Template Destroyed"
		redirect_to templates_path
	end


end
