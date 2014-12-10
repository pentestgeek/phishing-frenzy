require 'rails_helper'

RSpec.describe "Admins", :type => :request do

  login_admin

  describe "GET /admins/list" do
    it "requests admin list page to view admins" do
      visit list_admin_index_path
      expect(page).to have_content("Your Registration")
    end

    it "approve an existing admins account" do
      create(:admin, :unapproved)
      visit list_admin_index_path
      first(:link, "Approve").click
      expect(page).to have_http_status(200)
    end

    it "revoke an existing admins account" do
      create(:admin)
      visit list_admin_index_path
      expect(page).to have_content("Revoke")
      first(:link, "Revoke")
      expect(page).to have_http_status(200)
    end

    it "delete an existing admins account" do
      create(:admin)
      visit list_admin_index_path
      first(:link, "Delete").click
      expect(page).to have_content("Admin Destroyed")
    end
  end

  describe "GET /admins/list?approved=false" do
    it "requests admins that have been registered but not approved" do
      visit list_admin_index_path(approved: "false")
      expect(page).to_not have_css("#content > div.Admin.list > table > tbody > tr")
    end

    it "requests admins that have been registered but not approved factory" do
      create(:admin, :unapproved)
      visit list_admin_index_path(approved: "false")
      expect(page).to have_css("#content > div.Admin.list > table > tbody > tr")
    end
  end

  describe "GET /admins/edit.1" do
    it "requests editing an existing admins account" do
      admin = create(:admin)
      visit edit_admin_registration_path(admin)
      expect(page).to have_content("Edit Admin")
    end

    it "edit an existing admin account and save changes with current password" do
      admin = create(:admin)
      visit edit_admin_registration_path(admin)
      fill_in("admin_username", with: "root")
      fill_in("admin_current_password", with: admin.password)
      click_on("Update")
      expect(page).to have_content("You updated your account successfully.")
    end

    it "edit an existing admin account and save changes without current password" do
      admin = create(:admin)
      visit edit_admin_registration_path(admin)
      fill_in("admin_username", with: "root")
      click_on("Update")
      expect(page).to have_content("Current password can't be blank")
    end
  end

  describe "GET /admin/1/logins" do
    it "request admin logins audit trail page" do
      admin = create(:admin)
      visit logins_admin_path(admin)
      expect(page).to have_content("Logins")
    end
  end

end
