require 'test_helper'

class ShopTagsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get shop_tags_new_url
    assert_response :success
  end

  test "should get edit" do
    get shop_tags_edit_url
    assert_response :success
  end

end
