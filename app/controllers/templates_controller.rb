class TemplatesController < ApplicationController

	def index
		list
		render('list')
	end

	def list
		@templates = Template.all
	end

	def show
		@template = Template.find_by_id(params[:id])
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
		@template = Template.find(params[:id])
	end

	def update
		@template = Template.find(params[:id])
		if @template.update_attributes(params[:template])
			redirect_to edit_template_path, notice: "Template Updated"
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
		@template = Template.find(params[:id])
		@template.destroy
		flash[:warning] = "Template Destroyed"
		redirect_to list_templates_path
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
		if params[:restore_template].nil?
			redirect_to :back, notice: 'No File Chosen'
			return false
		end

		uploaded_io = params[:restore_template]
		# check to make sure a zip file was retrieved
		unless uploaded_io.original_filename =~ /zip/
			flash[:notice] = "Error: Must be Zip File"
			redirect_to(:controlloer => 'templates', :action => 'list')
			return false		
		end

		zip_upload_location = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
		tmp_location = Rails.root.join('tmp', 'cache')

		# upload template archive
		File.open(Rails.root.join(zip_upload_location), 'w+b') do |file|
			file.write(uploaded_io.read)
		end

		# unzip uploaded template archive
		template_yml = Zip::File.open(zip_upload_location).find { |file| file.name =~ /template.yml$/ }
		attachments_yml = Zip::File.open(zip_upload_location).find { |file| file.name =~ /attachments.yml$/ }
		if template_yml.nil? or attachments_yml.nil?
			redirect_to :back, notice: 'Not a backup archive: Missing template.yaml'
			return false
		end

		# load template.yml file and create template db entry
		template = YAML.load(template_yml.get_input_stream.read)
		new_template = template.dup
		new_template.save!(validate: false)

		# read attachments object from yml file
		Attachment.new
		attachments = YAML.load(attachments_yml.get_input_stream.read)

		template_location = File.join(tmp_location, template.name.parameterize)
		# for each file in zip archive
		Zip::File.open(zip_upload_location) { |zipfile|
			zipfile.each { |file|
				# do something with file
				next if file.name.eql? "template.yml" or file.name.eql? "attachments.yml"
				FileUtils.mkdir_p(template_location) unless Dir.exists?(template_location)
				begin
					zipfile.extract(file, File.join(template_location, file.name))
				rescue Zip::ZipDestinationFileExistsError
					# if file already exists create random name to handle it
					zipfile.extract(file, File.join(template_location, "#{file.name}_#{(0...8).map { (65 + rand(26)).chr }.join}"))
				rescue => e
					redirect_to templates_path, notice: "Template Upload Issue: #{e}"
					return false
				end
			}
		}

		filenames = Dir.glob(File.join(template_location, '*')).map{|filepath| File.basename(filepath)}
		attachments.each do |attachment|
			# add each attachment to template
			filename = File.basename(attachment.file.to_s)
			t = new_template.attachments.create(function: attachment.function)
			begin
				t.file = File.new(File.join(template_location, filename))
			rescue Errno::EACCES => e
				redirect_to templates_path, notice: "File Permission Issues (chmod): #{e}"
				return
			end
			t.save!		
		end

		# cleanup original uploaded zip file and tmp template
		FileUtils.rm(zip_upload_location)
		FileUtils.rm_rf(template_location)

		redirect_to list_templates_path, notice: "Template Restored"
	end

	def edit_email
		@attachment = Attachment.find(params[:format])
		attachment_location = File.join(Rails.root.to_s, "public", "uploads", "attachment", "file", params[:format], "*")

		begin
			@attachment_content = File.read(Dir.glob(attachment_location)[0])
		rescue
			flash[:warning] = "Issue Reading Attachment File"
			redirect_to :back
			return
		end
		if File.binary?(Dir.glob(attachment_location)[0])
			flash[:warning] = "Cannot Edit Binary Files"
			redirect_to :back
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
		random_string = (0...8).map { (65 + rand(26)).chr }.join

		# copy template attributes to new_template object
		new_template = template.dup

		# copy template attachments to newly created template object
		template.attachments.each do |a|
			#new_template.attachments << a.dup
			# add each attachment to template
			filename = File.basename(a.file.to_s)
			t = new_template.attachments.new(function: a.function)
			t.file = a.file
			t.save!		
		end

		# change location and name for template
		new_template.name ="#{template.name} #{random_string}"
		new_template.location = "#{template.location}_#{random_string}"

		if new_template.save(validate: false)
			#FileUtils.cp_r(File.join(Rails.root.to_s, 'public', 'templates', template.location), 
			#File.join(Rails.root.to_s, 'public', 'templates', new_template.location))
			redirect_to list_templates_path, notice: "Template copy complete"
		else
			redirect_to list_templates_path, notice: "Issues Saving Template"
		end
	end

	def download(template)
		begin
			zipfile_name = template.name? ? "#{template.name.parameterize}.zip" : "backup.zip"
			zipfile_location = Rails.root.join('tmp', 'cache', zipfile_name)
			Zip::File.open(zipfile_location, Zip::File::CREATE) do |zipfile|
				zipfile.get_output_stream("template.yml") { |f| f.puts template.to_yaml }
				zipfile.get_output_stream("attachments.yml") { |f| f.puts template.attachments.to_yaml }
				template.attachments.each do |attachment|
					zipfile.add(attachment.file.file.identifier, attachment.file.current_path) {true}
				end
			end

			# send archive to browser for download
			send_file zipfile_location, :type => 'application/zip', :disposition => 'attachment', :filename => "#{template.name}.zip".gsub(' ', '_').downcase
		rescue => e
			flash[:notice] = "Issues Zipping: #{e}"
			redirect_to(:action => 'show', :id => template.id)
		end
	end

end
