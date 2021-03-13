require 'test_helper'

class CartItems::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get cart_items_orders_new_url
    assert_response :success
  end

  test "should get create" do
    get cart_items_orders_create_url
    assert_response :success
  end

end
