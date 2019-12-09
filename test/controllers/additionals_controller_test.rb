require 'test_helper'

class AdditionalsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get additionals_new_url
    assert_response :success
  end

  test "should get create" do
    get additionals_create_url
    assert_response :success
  end

  test "should get edit" do
    get additionals_edit_url
    assert_response :success
  end

  test "should get update" do
    get additionals_update_url
    assert_response :success
  end

end
