require 'test_helper'

class MenuImagesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get menu_images_new_url
    assert_response :success
  end

  test "should get edit" do
    get menu_images_edit_url
    assert_response :success
  end

end
