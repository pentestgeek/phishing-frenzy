require 'rails_helper'

RSpec.describe "Templates", :type => :request do

  login_admin

  describe "GET /templates/list" do
    it "request the list templates page" do
      visit list_templates_path
      expect(page).to have_content("Templates")
    end

    it "create a new template" do
      template = build(:template)
      visit list_templates_path
      click_on("Create")
      fill_in("template_name", with: template.name)
      fill_in("template_description", with: template.description)
      click_on("Create Template")
      expect(page).to have_content("Template Created")
    end

    it "destroy an existing template" do
      template = create(:template)
      visit list_templates_path
      all("#delete")[0].click
      expect(page).to have_content("Template Destroyed")
    end

    it "restore an existing template using a zip archive upload" do
      visit list_templates_path
      click_on("Restore")
      attach_file("restore_template", "spec/support/files/templates/archive_good.zip")
      click_on("Restore Template")
      expect(page).to have_content("Template Restored")
    end

    it "restore a template using a zip archive with no template.yml file" do
      visit list_templates_path
      click_on("Restore")
      attach_file("restore_template", "spec/support/files/templates/archive_no_template_yaml.zip")
      click_on("Restore Template")
      expect(page).to have_content("Not a backup archive: Missing template.yaml")
    end

    it "restore a template using a zip archive with a non .zip extension name" do
      visit list_templates_path
      click_on("Restore")
      attach_file("restore_template", "spec/support/files/templates/archive_good.docx")
      click_on("Restore Template")
      expect(page).to have_content("Error: Must be Zip File")
    end

    it "copy an existing template" do
      create(:template)
      visit list_templates_path
      all("#copy")[0].click
      expect(page).to have_content("Template copy complete")
    end
  end

  describe "GET /templates/1" do
    it "requst the show page of an existing template" do
      template = create(:template)
      visit template_path(template)
      expect(page).to have_content("Template Details")
    end
  end

  describe "GET /templates/1/edit" do
    it "request edit an existing template" do
      template = create(:template)
      visit edit_template_path(template)
      expect(page).to have_content("Update Phishing Template")
    end
  end

end
