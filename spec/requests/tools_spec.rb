require 'rails_helper'

RSpec.describe "Tools", :type => :request do

  login_admin

  describe "GET /tools/emails" do
    it "request email enumeration page without bing API key entered in global settings" do
      visit tools_emails_path
      expect(page).to have_content("Bing API Key Required for Email Enumeration")
    end

    it "request email enumeration page with bing API key entered in global settings" do
      global_settings = GlobalSettings.first
      global_settings.bing_api = "BKqC2hIKr8foem2E1qiRvB5ttBQJK8objH8kZE/WJVs="
      global_settings.save
      visit tools_emails_path
      expect(page).to_not have_content("Bing API Key Required for Email Enumeration")
    end

    it "perform email harvesting process without bing API key entered in global settings" do
      visit tools_emails_path
      fill_in("domain", with: "Domain Harvesting")
      select("50", from: "crawls")
      click_on("Enumerate Emails")
      expect(page).to have_content("Unable to perform Operation without Bing API Key")
    end

    it "perform email harvesting process with bing API key entered but invalid" do
      global_settings = GlobalSettings.first
      global_settings.bing_api = "BKqC2hIKr8foem2E1qiRvB5ttBQJK8objH8kZE/WJVs="
      global_settings.save
      visit tools_emails_path
      fill_in("domain", with: "domain.net")
      select("50", from: "crawls")
      click_on("Enumerate Emails")
      expect(page).to have_content("Invalid Bing API Key")
    end
  end

end
