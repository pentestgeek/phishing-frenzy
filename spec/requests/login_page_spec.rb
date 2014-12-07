require 'rails_helper'

RSpec.describe "LoginPage", :type => :request do

  describe "GET /admin/sign_in" do
    it "login success with valid credentials" do
      visit new_admin_session_path
      fill_in('Username', with: "admin")
      fill_in('Password', with: "Funt1me!")
      click_on("Sign in")
      expect(page).to have_content("Signed in successfully")
    end
  end

  describe "GET /admin/sign_in" do
    it "login failure with invalid credentials" do
      visit new_admin_session_path
      fill_in('Username', with: "admin")
      fill_in('Password', with: "wrongpasswd")
      click_on("Sign in")
      expect(page).to have_content("Invalid email or password")
    end
  end

  describe "GET /admin/sign_in" do
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
  end

  describe "GET /admin/sign_in" do
    it "sign up with invalid account information for new account" do
      visit new_admin_session_path
      click_on("Sign up")
      fill_in("admin_username", with: "johnny")
      fill_in("admin_password", with: "SecretPasswd321!")
      click_on("Sign up")
      expect(page).to have_content("errors")
    end
  end

  describe "GET /admin/sign_in" do
    it "sign in with an account registered but not approved" do
      # create Johnny record
      Admin.create(username: "johnny", password: "SecretPasswd321!", 
                      password_confirmation: "SecretPasswd321!",
                      email: "jsmith@phishingfrenzy.local",
                      name: "John Smith")

      visit new_admin_session_path
      fill_in("Username", with: "johnny")
      fill_in("Password", with: "SecretPasswd321!")
      click_on("Sign in")
      expect(page).to have_content("Your account has not been approved by your administrator yet.")
    end
  end

  describe "GET /admin/sign_in" do
    it "sign in with an account registered and approved to login" do
      # create Johnny record
      Admin.create(username: "johnny", password: "SecretPasswd321!", 
                      password_confirmation: "SecretPasswd321!",
                      email: "jsmith@phishingfrenzy.local",
                      name: "John Smith",
                      approved: true)

      visit new_admin_session_path
      fill_in("Username", with: "johnny")
      fill_in("Password", with: "SecretPasswd321!")
      click_on("Sign in")
      expect(page).to have_content("Signed in successfully.")
    end
  end

end
