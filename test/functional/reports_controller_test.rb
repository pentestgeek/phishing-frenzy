require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

end
