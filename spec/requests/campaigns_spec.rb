require 'rails_helper'

RSpec.describe "Campaigns", :type => :request do

  login_admin

  describe "GET /" do
    it "request the dashboard of campaigns" do
      visit root_path
      expect(page).to have_content("Dashboard")
    end

    it "clicks on the reports button for an existing campaign from the dashboard" do
      create(:campaign, :launched)
      visit root_path
      within("#content") do
        first(:link, "Reports").click
      end
      expect(page).to have_content("Campaign Name")
    end

    it "clicks on the manage button for an existing campaign from the dashboard" do
      create(:campaign, :launched)
      visit root_path
      within("#content") do
        first(:link, "Manage").click
      end
      expect(page).to have_content("Campaign Options")
    end
  end

  describe "GET /campaigns" do
    it "logout of the application successfully" do
      visit list_campaigns_path
      expect(page).to have_content("Campaigns")
      click_on("Logout")
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end

  describe "GET /campaigns/list" do
    it "create new campaign" do
      visit list_campaigns_path
      click_on("New Campaign")
      fill_in("campaign_name", with: "SOA Phishing")
      fill_in("campaign_description", with: "Watch out for Jax")
      click_on("Create Campaign")
      expect(page).to have_content("Campaign Created")
    end

    it "delete an existing campaign" do
      create(:campaign)
      visit list_campaigns_path
      click_on("Delete Campaign")
      expect(page).to have_content("Campaign Destroyed")
    end

    it "request campaign options for existing campaign" do
      create(:campaign)
      visit list_campaigns_path
      click_on("Campaign Options")
      expect(page).to have_content("Campaign Options - ")
    end
  end

  describe "GET /campaigns/1" do
    it "populate campaign options and ensure all settings saved to campaign" do
      campaign = create(:campaign)
      visit campaign_path(campaign)
      fill_in("campaign_test_email", with: "user@phishingfrenzy.local")
      fill_in("campaign_email_settings_attributes_smtp_server", with: "smtp.secureserver.net")
      fill_in("campaign_email_settings_attributes_smtp_server_out", with: "smtpout.secureserver.net")
      fill_in("campaign_email_settings_attributes_domain", with: "phishingfrenzy.local")
      fill_in("campaign_email_settings_attributes_smtp_username", with: "user@phishingfrenzy.local")
      fill_in("campaign_email_settings_attributes_smtp_password", with: "secretPasswd")
      fill_in("campaign_email_settings_attributes_smtp_port", with: "3535")
      fill_in("campaign_email_settings_attributes_subject", with: "Subject Line")
      fill_in("campaign_email_settings_attributes_from", with: "user@phishingfrenzy.local")
      fill_in("campaign_email_settings_attributes_display_from", with: "Display From")
      fill_in("campaign_email_settings_attributes_phishing_url", with: "sub.phishingfrenzy.local")
      fill_in("campaign_campaign_settings_attributes_fqdn", with: "sub.phishingfrenzy.local")
      click_on("Save Settings")
      expect(page).to have_selector("#campaign_test_email[value='user@phishingfrenzy.local']")
      expect(page).to have_selector("#campaign_email_settings_attributes_smtp_server[value='smtp.secureserver.net']")
      expect(page).to have_selector("#campaign_email_settings_attributes_smtp_server_out[value='smtpout.secureserver.net']")
      expect(page).to have_selector("#campaign_email_settings_attributes_domain[value='phishingfrenzy.local']")
      expect(page).to have_selector("#campaign_email_settings_attributes_smtp_username[value='user@phishingfrenzy.local']")
      expect(page).to have_selector("#campaign_email_settings_attributes_smtp_password[value='secretPasswd']")
      expect(page).to have_selector("#campaign_email_settings_attributes_smtp_port[value='3535']")
      expect(page).to have_selector("#campaign_email_settings_attributes_subject[value='Subject Line']")
      expect(page).to have_selector("#campaign_email_settings_attributes_from[value='user@phishingfrenzy.local']")
      expect(page).to have_selector("#campaign_email_settings_attributes_display_from[value='Display From']")
      expect(page).to have_selector("#campaign_email_settings_attributes_phishing_url[value='sub.phishingfrenzy.local']")
      expect(page).to have_selector("#campaign_campaign_settings_attributes_fqdn[value='sub.phishingfrenzy.local']")
    end

    it "import targets into an existing campaign" do
      campaign = create(:campaign)
      visit campaign_path(campaign)
      fill_in("campaign_emails", with: "email@phishingfrenzy.local")
      click_on("Save Settings")
      within("#collapseOne > div > div:nth-child(5) > div.col-xs-3") do
        click_on("1")
      end
      expect(page).to have_content("email@phishingfrenzy.local")
    end

    it "deletes a target from an existing campaign" do
      campaign = create(:campaign)
      visit campaign_path(campaign)
      fill_in("campaign_emails", with: "email@phishingfrenzy.local")
      click_on("Save Settings")
      within("#collapseOne > div > div:nth-child(5) > div.col-xs-3") do
        click_on("1")
      end
      click_on("delete")
      expect(page).to_not have_css("#victim-3 > td:nth-child(1)")
    end

    it "deletes all targets from an existing campaign" do
      campaign = create(:campaign)
      visit campaign_path(campaign)
      fill_in("campaign_emails", with: "email@phishingfrenzy.local")
      click_on("Save Settings")
      within("#collapseOne > div > div:nth-child(5) > div.col-xs-3") do
        click_on("1")
      end
      click_on("Delete all")
      expect(page).to have_content("Victims Cleared")
    end

    it "preview campaign email without assigning a template" do
      campaign = create(:campaign)
      campaign.campaign_settings.update_attributes(attributes_for(:campaign_settings))
      campaign.email_settings.update_attributes(attributes_for(:email_settings))
      visit campaign_path(campaign)
      click_on("Preview")
      expect(page).to have_content("Template is missing an email file, upload and create new email")
    end

    it "test campaign email without assigning a template" do
      campaign = create(:campaign)
      campaign.campaign_settings.update_attributes(attributes_for(:campaign_settings))
      campaign.email_settings.update_attributes(attributes_for(:email_settings))
      visit campaign_path(campaign)
      click_on("Test")
      expect(page).to have_content("No template has been selected for this campaign")
    end

    it "preview campaign email with a template assigned" do
      campaign = create(:campaign)
      visit campaign_path(campaign)
      select("Intel Password Checker", from: "campaign_template_id")
      click_on("Save Settings")
      expect(page).to have_content("Campaign Updated")
      click_on("Preview")
      expect(page).to have_content("Campaign test email available for preview")
    end

    it "test campaign email with a template assigned" do
      campaign = create(:campaign)
      visit campaign_path(campaign)
      select("Intel Password Checker", from: "campaign_template_id")
      click_on("Save Settings")
      click_on("Test")
      expect(page).to have_content("Campaign test email sent")
      expect(page).to have_css("#recentBlasts > div > table > tbody > tr:nth-child(1)")
    end

    it "launch campaign with a template assigned" do
      campaign = create(:campaign)
      visit campaign_path(campaign)
      select("Intel Password Checker", from: "campaign_template_id")
      fill_in("campaign_campaign_settings_attributes_fqdn", with: Faker::Internet.domain_name)
      click_on("Save Settings")
      click_on("Launch")
      expect(page).to have_content("Campaign blast launched")
    end

    it "edit email from campaign options" do
      campaign = create(:campaign)
      visit campaign_path(campaign)
      select("Intel Password Checker", from: "campaign_template_id")
      click_on("Save Settings")
      click_on("Edit Email")
      expect(page).to have_content("Update Phishing Template")
    end

    it "request blast#show page from campaign options" do
      campaign = create(:campaign)
      visit campaign_path(campaign)
      select("Intel Password Checker", from: "campaign_template_id")
      click_on("Save Settings")
      click_on("Test")
      page.find("#recentBlasts > div > table > tbody > tr:nth-child(1) > td:nth-child(1) > a").click
      expect(page).to have_content("SMTP Logs")
    end
  end

  describe "GET /campaigns/aboutus" do
    it "requests the about us page" do
      visit aboutus_campaigns_path
      expect(page).to have_content("Resources")
    end
  end

end
