require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get games_new_url
    assert_response :success
  end

  test "should get scor" do
    get games_scor_url
    assert_response :success
  end

end
