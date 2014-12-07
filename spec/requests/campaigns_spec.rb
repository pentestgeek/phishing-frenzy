require 'rails_helper'

RSpec.describe "Campaigns", :type => :request do

	login_admin

  describe "GET /campaigns" do
    it "logout of the application successfully" do
      visit list_campaigns_path
      expect(page).to have_content("Campaigns")
      click_on("Logout")
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end

  describe "GET /" do
    it "request the dashboard of campaigns" do
      visit root_path
      expect(page).to have_content("Dashboard")
    end
  end
end
