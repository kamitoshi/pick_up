require 'test_helper'

class ShopContactsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shop_contacts_index_url
    assert_response :success
  end

  test "should get show" do
    get shop_contacts_show_url
    assert_response :success
  end

end
