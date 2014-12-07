module ControllerMacros
  def login_admin
    before(:each) do
      login_as build(:admin) # Using factory girl as an example
    end
  end
end