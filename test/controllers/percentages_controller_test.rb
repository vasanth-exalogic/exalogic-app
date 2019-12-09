require 'test_helper'

class PercentagesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get percentages_edit_url
    assert_response :success
  end

  test "should get update" do
    get percentages_update_url
    assert_response :success
  end

end
