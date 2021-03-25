require 'test_helper'

class Shops::MenusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shops_menus_index_url
    assert_response :success
  end

  test "should get show" do
    get shops_menus_show_url
    assert_response :success
  end

end
