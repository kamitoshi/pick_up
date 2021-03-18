require 'test_helper'

class Users::ShopsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_shops_index_url
    assert_response :success
  end

  test "should get show" do
    get users_shops_show_url
    assert_response :success
  end

end
