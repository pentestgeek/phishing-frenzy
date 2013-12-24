namespace :templates do
  task update: :environment do
    t = Template.where(name: 'New Intel Password Checker').first
    unless t.attachments.size > 0
      a = t.attachments.create(function: 'website')
      a.file = File.open("#{Rails.root}/vendor/templates/intel/index.php")
      a.save!
      a = t.attachments.create(function: 'website')
      a.file = File.open("#{Rails.root}/vendor/templates/intel/index2.php")
      a.save!
      a = t.attachments.create(function: 'email')
      a.file = File.open("#{Rails.root}/vendor/templates/intel/intel.html.erb")
      a.save!
      a = t.attachments.create(function: 'attachment')
      a.file = File.open("#{Rails.root}/vendor/templates/intel/intel.jpg")
      a.save!
    end

    t = Template.where(name: 'New Efax').first
    unless t.attachments.size > 0
      a = t.attachments.create(function: 'website')
      a.file = File.open("#{Rails.root}/vendor/templates/efax/index.php")
      a.save!
      a = t.attachments.create(function: 'email')
      a.file = File.open("#{Rails.root}/vendor/templates/efax/efax.html.erb")
      a.save!
      a = t.attachments.create(function: 'attachment')
      a.file = File.open("#{Rails.root}/vendor/templates/efax/efax.jpg")
      a.save!
    end
  end

  task load: :environment do
    t = Template.create(name: 'New Intel Password Checker', description: 'Users test the strength of their password')
    a = t.attachments.create(function: 'website')
    a.file = File.open("#{Rails.root}/vendor/templates/intel/index.php")
    a.save!
    a = t.attachments.create(function: 'website')
    a.file = File.open("#{Rails.root}/vendor/templates/intel/index2.php")
    a.save!
    a = t.attachments.create(function: 'email')
    a.file = File.open("#{Rails.root}/vendor/templates/intel/intel.html.erb")
    a.save!
    a = t.attachments.create(function: 'attachment')
    a.file = File.open("#{Rails.root}/vendor/templates/intel/intel.jpg")
    a.save!
    t = Template.create(name: 'New Efax', description: 'User received a efax which requires them to open the PDF')
    a = t.attachments.create(function: 'website')
    a.file = File.open("#{Rails.root}/vendor/templates/efax/index.php")
    a.save!
    a = t.attachments.create(function: 'email')
    a.file = File.open("#{Rails.root}/vendor/templates/efax/efax.html.erb")
    a.save!
    a = t.attachments.create(function: 'attachment')
    a.file = File.open("#{Rails.root}/vendor/templates/efax/efax.jpg")
    a.save!
  end
end