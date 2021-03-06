require 'test_helper'

class Users::MenusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_menus_index_url
    assert_response :success
  end

  test "should get show" do
    get users_menus_show_url
    assert_response :success
  end

end
