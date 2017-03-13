require 'rails_helper'
require 'devise'

describe SystemLogsController, type: :controller do
  login_controller_admin

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

end
