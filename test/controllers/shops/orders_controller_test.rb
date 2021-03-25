require 'test_helper'

class Shops::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shops_orders_index_url
    assert_response :success
  end

  test "should get show" do
    get shops_orders_show_url
    assert_response :success
  end

  test "should get update" do
    get shops_orders_update_url
    assert_response :success
  end

end
