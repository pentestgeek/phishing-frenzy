class TemplatesController < ApplicationController
	before_filter :confirm_logged_in

	def index
		list
		render('list')
	end

	def list
		@templates = Template.order("templates.id ASC")
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

		if not @template.valid?
			render('new')
			return
		end

		# check if folder already exists
		if folder_exists?(@template.location)
			render('new')
			return
		else
			Dir.mkdir(File.join(Rails.root.to_s, 'public', 'templates', @template.location), 0700)
			Dir.mkdir(File.join(Rails.root.to_s, 'public', 'templates', @template.location, 'email'), 0700)
			Dir.mkdir(File.join(Rails.root.to_s, 'public', 'templates', @template.location, 'www'), 0700)
			File.new(File.join(Rails.root.to_s, 'public', 'templates', @template.location, 'email', 'email.txt'), 0700)
			File.new(File.join(Rails.root.to_s, 'public', 'templates', @template.location, 'www', 'index.php'), 0700)
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
		redirect_to(:action => 'list')
	end

	def folder_exists?(location)
		if File.directory? File.join(Rails.root.to_s, 'public', 'templates', location)
			return true
		else
			return false
		end
	end

	def copy
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			list
			render('list')
		end
	end

	def copy_template
		@template = Template.find_by_id(params[:id])
		if @template.nil?
			list
			render('list')
		end

		# check if folder already exists
		if folder_exists?(params[:new_location])
			flash[:notice] = "Folder Already Exists"
			redirect_to(:action => 'copy', :id => @template.id)
			return
		else
			# copy folder to new destination
			FileUtils.cp_r(File.join(Rails.root.to_s, 'public', 'templates', @template.location), File.join(Rails.root.to_s, 'public', 'templates', params[:new_location]))
		end

		# add new template database entry
		new_template = Template.new
		new_template.location = params[:new_location]
		new_template.name = params[:new_name]

		if new_template.save
			flash[:notice] = "Template Copied"
			redirect_to(:action => 'list')
		else
			flash[:notice] = "Issues Saving New Template"
			redirect_to(:action => 'copy', :id => @template.id)
			return
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
		# load yaml file
		#location = File.join(Rails.root.to_s, 'public', 'templates', 'microsoft_update', 'backup.yaml')
		#backup = YAML.load(File.read(location))
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
		new_template.save!

		template_location = File.join(Rails.root.to_s, "public", "templates", "#{new_template.location}")
		if Dir.exist?(template_location)
			# append random location and update db
			random_string = (0...8).map { (65 + rand(26)).chr }.join
			new_template.location += "_#{random_string}"
			new_template.save!
			template_location += "_#{random_string}"
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

		flash[:notice] = "File Uploaded"
		redirect_to(:controlloer => 'templates', :action => 'list')
	end

	def edit_email
		@campaign = Campaign.find_by_id(params[:id])
		@template = Template.find_by_id(@campaign.template_id)
		if @template.nil?
			flash[:notice] = "Template not found"
			redirect_to(:controlloer => 'templates', :action => 'list')
		end

		# text_box with email.txt displaying
		email_location = File.join(Rails.root.to_s, "public", "templates", "#{@template.location}", "email", "email.txt")
		@email_content = File.read(email_location)
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
		campaign = Campaign.find_by_id(params[:id])
		#binding.pry
		@template = Template.find_by_id(campaign.template_id)
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
end
