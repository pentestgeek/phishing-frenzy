require 'rails_helper'

RSpec.describe "Clones", :type => :request do

  login_admin

  describe "GET /clones" do
    it "requests the website cloner page" do
      visit clones_path
      expect(page).to have_content("Websites Cloned")
    end

    it "clones a sample website using http syntax" do
      visit clones_path
      fill_in("clone_name", with: "Google Clone")
      fill_in("clone_url", with: "http://google.com")
      page.find("#new_clone > div.actions > input").click
      expect(page).to have_content("Clone was successfully created.")
    end

    it "clones a sample website using valid https syntax" do
      visit clones_path
      fill_in("clone_name", with: "Google Clone")
      fill_in("clone_url", with: "https://google.com")
      page.find("#new_clone > div.actions > input").click
      expect(page).to have_content("Clone was successfully created.")
    end

    it "clones a sample website using invalid format: google.com)" do
      visit clones_path
      fill_in("clone_name", with: "Google Clone")
      fill_in("clone_url", with: "google.com")
      page.find("#new_clone > div.actions > input").click
      expect(page).to_not have_content("Clone was successfully created.")
    end

    it "deletes an already existing website clone" do
      create(:clone)
      visit clones_path
      click_on("Delete")
      expect(page).to have_content("Website Deleted")
    end

    it "downloads an already existing website clone" do
      create(:clone)
      visit clones_path
      click_on("Download")
      expect(page).to have_http_status(200)
    end

    it "previews an already existing website clone" do
      create(:clone)
      visit clones_path
      click_on("Preview")
      expect(page).to have_http_status(200)
    end

  end
end
