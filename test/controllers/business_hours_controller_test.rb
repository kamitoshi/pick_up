require 'test_helper'

class BusinessHoursControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get business_hours_new_url
    assert_response :success
  end

  test "should get edit" do
    get business_hours_edit_url
    assert_response :success
  end

end
