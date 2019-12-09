require 'test_helper'

class DetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get details_new_url
    assert_response :success
  end

  test "should get create" do
    get details_create_url
    assert_response :success
  end

  test "should get edit" do
    get details_edit_url
    assert_response :success
  end

  test "should get update" do
    get details_update_url
    assert_response :success
  end

end
