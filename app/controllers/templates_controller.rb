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
	end

	def update
		#binding.pry
		attachments = params[:template][:attachments_attributes]
		unless attachments.to_s.empty?
			attachments.each do |attachment|
				#binding.pry
				#if attachment[1][:_destroy] == "1"
					#binding.pry
					#attachment.delete_if {|key, value| value == "testC@test.com" } 
					#attachment_record = Attachment.find_by_id(attachment[1][:id])
					#attachment_record.destroy if attachment_record
				#end
			end
		end

		@template = Template.find(params[:id])
		if @template.update_attributes(params[:template])
			flash[:notice] = "Template Updated"
			render('edit')
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
		@template = Template.find(params[:id])
		if @template.attachments.empty?
			list
			render('list')
		end

		download(@template)		
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
		attachment_location = File.join(Rails.root.to_s, "public", "uploads", "attachment", "file", params[:format], "*")
		@attachment_content = File.read(Dir.glob(attachment_location)[0])
		if File.binary?(Dir.glob(attachment_location)[0])
			flash[:notice] = "Cannot Edit Binary Files"
			redirect_to(:controlloer => 'templates', :action => 'edit', :id => params[:id])
		end
	end

	def update_attachment
		attachment_location = File.join(Rails.root.to_s, "public", Attachment.find(params[:format]).file.to_s)
		File.open(attachment_location, "w+") do |f|
			f.write(params[:attachment_content])
		end
		redirect_to :back, notice: 'Attachment Updated'
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

	def download(template)
		begin
			zipfile_name = @template.name? ? "#{@template.name.parameterize}.zip" : "backup.zip"
			zipfile_location = Rails.root.join('tmp', 'cache', zipfile_name)
			Zip::File.open(zipfile_location, Zip::File::CREATE) do |zipfile|
				zipfile.get_output_stream("template.yml") { |f| f.puts @template.to_yaml }
				zipfile.get_output_stream("attachments.yml") { |f| f.puts @template.attachments.to_yaml }
				template.attachments.each do |attachment|
					zipfile.add(attachment.file.file.identifier, attachment.file.current_path) {true}
				end
			end

			# send archive to browser for download
			send_file zipfile_location, :type => 'application/zip', :disposition => 'attachment', :filename => "#{@template.name}.zip".gsub(' ', '_').downcase
		rescue => e
			flash[:notice] = "Issues Zipping: #{e}"
			redirect_to(:action => 'show', :id => @template.id)
		end
	end

end
