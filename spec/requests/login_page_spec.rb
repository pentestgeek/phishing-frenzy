require 'rails_helper'

RSpec.describe "LoginPage", :type => :request do

  describe "GET /admin/sign_in" do
    it "login success with default credentials" do
      admin = create(:admin)
      visit new_admin_session_path
      fill_in('Username', with: admin.username)
      fill_in('Password', with: admin.password)
      click_on("Sign in")
      expect(page).to have_content("Signed in successfully")
    end

    it "login failure with invalid credentials" do
      visit new_admin_session_path
      fill_in('Username', with: "admin")
      fill_in('Password', with: "wrongpasswd")
      click_on("Sign in")
      expect(page).to have_content("Invalid email or password")
    end

    it "sign up with valid account information for new account" do
      visit new_admin_session_path
      click_on("Sign up")
      fill_in("admin_username", with: "johnny")
      fill_in("admin_name", with: "John Smith")
      fill_in("admin_email", with: "jsmith@phishingfrenzy.local")
      fill_in("admin_password", with: "SecretPasswd321!")
      fill_in("admin_password_confirmation", with: "SecretPasswd321!")
      click_on("Sign up")
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    it "sign up with invalid account information for new account" do
      visit new_admin_session_path
      click_on("Sign up")
      fill_in("admin_username", with: "johnny")
      fill_in("admin_password", with: "SecretPasswd321!")
      click_on("Sign up")
      expect(page).to have_content("errors")
    end

    it "sign in with an account registered but not approved" do
      admin = create(:admin, :unapproved)
      visit new_admin_session_path
      fill_in("Username", with: admin.username)
      fill_in("Password", with: admin.password)
      click_on("Sign in")
      expect(page).to have_content("Your account has not been approved by your administrator yet.")
    end

    it "sign in with an account registered and approved to login" do
      admin = create(:admin)
      visit new_admin_session_path
      fill_in("Username", with: admin.username)
      fill_in("Password", with: admin.password)
      click_on("Sign in")
      expect(page).to have_content("Signed in successfully.")
    end

    it "sign in with an account registered and approved but wrong password" do
      admin = create(:admin)
      visit new_admin_session_path
      fill_in("Username", with: admin.username)
      fill_in("Password", with: "wrongpasswd!")
      click_on("Sign in")
      expect(page).to have_content("Invalid email or password.")
    end
  end

end
