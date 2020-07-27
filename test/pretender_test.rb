require_relative "test_helper"

class PretenderTest < ActionDispatch::IntegrationTest
  def setup
    User.delete_all
  end

  def test_works
    admin = User.create!(name: "Admin")
    user = User.create!(name: "User")

    get root_url
    assert_response :success

    assert_equal admin, current_user
    assert_equal admin, true_user

    post impersonate_url
    assert_response :success

    assert_equal user, current_user
    assert_equal admin, true_user

    post stop_impersonating_url
    assert_response :success

    assert_equal admin, current_user
    assert_equal admin, true_user
  end

  private

  def current_user
    controller.current_user
  end

  def true_user
    controller.true_user
  end
end
