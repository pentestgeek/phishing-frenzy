module ControllerMacros
  def login_admin
    before(:each) do
      login_as create(:admin)
    end
  end
end