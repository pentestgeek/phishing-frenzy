module ControllerMacros
  # Used for request Capybara specs
  def login_admin
    before(:each) do
      login_as create(:admin)
    end
  end

  # Used for normal controller specs
  def login_controller_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryGirl.create(:admin) # Using factory girl as an example
    end
  end
end
