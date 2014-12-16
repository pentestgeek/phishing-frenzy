require 'rails_helper'

RSpec.describe "Reports", :type => :request do

  login_admin

  describe "GET /reports/list" do
    it "request the reports list page" do
      visit list_reports_path
      expect(page).to have_content("Reports")
    end

    it "request the reports list page when a campaign has been launched" do
      create(:campaign, :launched)
      visit list_reports_path
      expect(page).to have_css("#launched-campains > tbody > tr > td.actions > a")
    end

    it "request the reports list page when a campaign has not been launched" do
      create(:campaign)
      visit list_reports_path
      expect(page).to_not have_css("#launched-campains > tbody > tr > td.actions > a")
    end
  end

  describe "GET /reports/stats?=1" do
    it "request stats page for a campaign" do
      campaign = create(:campaign, :launched)
      visit stats_reports_path(id: campaign)
      expect(page).to have_content("Campaign Name")
    end

    it "download XML campaign report" do
      campaign = create(:campaign, :launched)
      visit stats_reports_path(id: campaign)
      click_on("Download XML Campaign Report")
      expect(page).to have_http_status(200)
    end

    it "download PDF campaign report" do
      campaign = create(:campaign, :launched)
      visit stats_reports_path(id: campaign)
      click_on("Download PDF Campaign Report")
      expect(page).to have_http_status(200)
    end

    it "download excel spreadsheet campaign report" do
      campaign = create(:campaign, :launched)
      visit stats_reports_path(id: campaign)
      click_on("Download Excel Spreadsheet from Campaign")
      expect(page).to have_http_status(200)
    end

    it "download raw apache logs from campaign" do
      campaign = create(:campaign, :launched)
      visit stats_reports_path(id: campaign)
      click_on("Download raw Apache Logs from Campaign")
      expect(page).to have_http_status(200)
    end

    it "view all smtp logs from campaign" do
      campaign = create(:campaign, :launched)
      visit stats_reports_path(id: campaign)
      click_on("View all SMTP logs from Campaign")
      expect(page).to have_http_status(200)
    end

    it "view all passwords harvested from campaign" do
      campaign = create(:campaign, :launched)
      visit stats_reports_path(id: campaign)
      click_on("View all Passwords Harvested")
      expect(page).to have_http_status(200)
    end

    it "view raw apache logs from campaign" do
      campaign = create(:campaign, :launched)
      visit stats_reports_path(id: campaign)
      click_on("View raw Apache Logs from Campaign")
      expect(page).to have_http_status(200)
    end

    it "clear campaign statistics"  do
      campaign = create(:campaign, :launched)
      visit stats_reports_path(id: campaign)
      click_on("Clear Campaign Statistics")
      expect(page).to have_content("Cleared Campaign Stats and removed Victims")
    end
  end

end
