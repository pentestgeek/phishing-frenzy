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

		@images = Dir[File.join(Rails.root.to_s, 'public', 'templates', @template.location, '*.{jpg,png,gif}')]

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

		if Template.folder_exists?(@template.location)
			FileUtils.rm_rf(File.join(Rails.root.to_s, 'public', 'templates', @template.location))
		end

		Template.find(params[:id]).destroy
		flash[:notice] = "Template Destroyed"
		redirect_to templates_path
	end

	def copy
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			list
			render('list')
		else
			# copy template
			copy_template(@template)
		end
	end

	def backup
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			list
			render('list')
		end

		# create yaml file
		location = File.join(Rails.root.to_s, 'public', 'templates', @template.location)
		File.open(File.join(location, 'backup.yaml'), "w+") do |f|
			f.write(@template.to_yaml)
		end

		download(location)		
	end

	def download(location)
		begin
			@template = Template.find_by_id(params[:id])
			if @template.nil?
				list
				render('list')
			end

			zipfile_name = File.join(location, 'backup.zip')

			# if backup file exists, delete it before archiving
			if File.exist?(zipfile_name)
				File.delete(zipfile_name)
			end

			Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
				Dir[File.join(location, '**', '**')].each do |file|
					zipfile.add(file.sub(location, '').gsub(/\A\//, ''), file) { true }
				end
			end

			# force browser to download file
			send_file zipfile_name, :type => 'application/zip', :disposition => 'attachment', :filename => "#{@template.name}.zip".gsub(' ', '_').downcase
		rescue => e
			flash[:notice] = "Issues Zipping Folder + #{e}"
			redirect_to(:action => 'show', :id => @template.id)
		end
	end

	def restore

	end

	def upload
		uploaded_io = params[:restore_template]
		zip_upload_location = Rails.root.join('public', 'uploads', uploaded_io.original_filename)

		# check to make sure a zip file was retrieved
		unless uploaded_io.original_filename =~ /zip/
			flash[:notice] = "Error: Must be Zip File"
			redirect_to(:controlloer => 'templates', :action => 'list')
			return false		
		end

		# upload template archive
		File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w+b') do |file|
			file.write(uploaded_io.read)
  		end

		# unzip uploaded template archive
		yaml_file = Zip::File.open(zip_upload_location).find { |file| file.name =~ /\.yaml$/ }
		template = YAML.load(yaml_file.get_input_stream.read)
		new_template = template.dup
		new_template.save!(validate: false)

		template_location = File.join(Rails.root.to_s, "public", "templates", "#{new_template.location}")
		if Template.folder_exists?(template_location)
			# append random location and update db
			random_string = Template.random_string
			new_template.location += "_#{random_string}"
			new_template.save!
		end

		# create directory for new template
		Dir.mkdir(template_location, 0700)

		Zip::File.open(zip_upload_location) { |zipfile|
			zipfile.each { |file| 
				# do something with file
				file_path = File.join(template_location, file.name)
				FileUtils.mkdir_p(File.dirname(file_path))
				zipfile.extract(file, file_path) unless File.exist?(file_path)
			}
		}

		# cleanup original uploaded zip file
		FileUtils.rm(zip_upload_location)

		flash[:notice] = "File Uploaded"
		redirect_to(:controlloer => 'templates', :action => 'list')
	end

	def edit_email
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			flash[:notice] = "Template not found"
			redirect_to(:back)
		else
			# text_box with email.txt displaying
			email_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "email", "email.txt")
			@email_content = File.read(email_location)
		end
	end

	def edit_www
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			flash[:notice] = "Template not found"
			redirect_to(:controlloer => 'templates', :action => 'list')
		end

		# text_box displaying file contents
		file_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "www", params[:filename])

		begin
			if File.binary?(file_location)
				flash[:notice] = "Cannot Edit Binary Files"
				redirect_to(:controlloer => 'templates', :action => 'edit', :id => params[:id])
			else
				@file_content = File.read(file_location)	
			end
		rescue => e
			flash[:notice] = "Error: #{e}"
			redirect_to(:controlloer => 'templates', :action => 'edit', :id => params[:id])
		end
	end

	def preview_email
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			flash[:notice] = "Template not found"
			redirect_to(:controller => 'templates', :action => 'list')
			return
		end

		# make sure email file exists
		@errors = []
		@preview = []

		email_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "email", "email.txt")
		if File.exist?(email_location)
			@errors << "[+] File exists"
			email_message = File.open(email_location, 'r')
		else
			@errors << "[-] Unable to Read #{email_location}"
		end

		# read email headers

		# read email contents
		email_message.each_line do |line|
			@preview << line
		end
	end

	def update_email_template
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			flash[:notice] = "Template not found"
			redirect_to(:controller => 'templates', :action => 'list')
			return
		end

		email_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "email", "email.txt")

		# write params[:email_content] out to a file
		File.open(email_location, "w+") do |f|
			f.write(params[:email_content])
		end

		flash[:notice] = "Email Message Updated"
		redirect_to(:controlloer => 'templates', :action => 'edit_email', :id => params[:id])
	end	

	def delete_email_template_file
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			flash[:notice] = "Template not found"
			redirect_to(:controller => 'templates', :action => 'list')
			return
		end

		file_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "email", params[:filename])
		FileUtils.rm(file_location)

		flash[:notice] = "#{params[:filename]} Removed"
		redirect_to(:controlloer => 'templates', :action => 'edit', :id => params[:id])
	end

	def update_www_template
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			flash[:notice] = "Template not found"
			redirect_to(:controller => 'templates', :action => 'list')
			return
		end

		file_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "www", params[:filename])

		# write params[:file_content] out to a file
		File.open(file_location, "w+") do |f|
			f.write(params[:file_content])
		end

		flash[:notice] = "Website Updated"
		redirect_to(:controlloer => 'templates', :action => 'edit', :id => params[:id])
	end

	def delete_www_template_file
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			flash[:notice] = "Template not found"
			redirect_to(:controller => 'templates', :action => 'list')
			return
		end

		file_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "www", params[:filename])
		FileUtils.rm(file_location)

		flash[:notice] = "#{params[:filename]} Removed"
		redirect_to(:controlloer => 'templates', :action => 'edit', :id => params[:id])
	end

	def new_www_file
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			flash[:notice] = "Template not found"
			redirect_to(:controller => 'templates', :action => 'list')
			return
		end
	end

	def create_www_file
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			flash[:notice] = "Template not found"
			redirect_to(:controller => 'templates', :action => 'list')
			return
		end

		file_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "www", params[:filename])

		begin
			FileUtils.touch(file_location)
			flash[:notice] = "File Created"
			redirect_to(:controller => 'templates', :action => 'edit', :id => @template.id)
		rescue => e
			flash[:notice] = "#{e}"
			redirect_to(:controller => 'templates', :action => 'edit', :id => @template.id)
		end
	end

	private

	def copy_template(template)
		# generate random string
		random_string = Template.random_string

		# copy template attributes to new_template object
		new_template = template.dup

		# change location and name for template
		new_template.name = "#{template.name} #{random_string}"
		new_template.location = "#{template.location}_#{random_string}"

		if new_template.save
			redirect_to list_templates_path, notice: "Template copy complete"
		else
			redirect_to list_templates_path, notice: "Issues Saving Template"
		end
	end
end
