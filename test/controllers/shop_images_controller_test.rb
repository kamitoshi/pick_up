require 'test_helper'

class ShopImagesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get shop_images_new_url
    assert_response :success
  end

  test "should get edit" do
    get shop_images_edit_url
    assert_response :success
  end

end
