require_relative "test_helper"

class PretenderTest < ActionDispatch::IntegrationTest
  def setup
    User.delete_all
  end

  def test_works
    admin = User.create!(name: "Admin")
    user = User.create!(name: "User")

    get users_url
    assert_response :success

    assert_equal admin, current_user
    assert_equal admin, true_user

    post impersonate_user_url(user.id)
    assert_response :success

    assert_equal user, current_user
    assert_equal admin, true_user

    post stop_impersonating_users_url
    assert_response :success

    assert_equal admin, current_user
    assert_equal admin, true_user
  end

  def test_cookie_store
    admin = User.create!(name: "Admin")
    user = User.create!(name: "User")

    post impersonate_cookie_user_url(user.id)
    assert_response :success

    assert_equal user, current_user
    assert_equal admin, true_user

    get cookie_users_url
    assert_equal user, current_user

    post stop_impersonating_cookie_users_url
    get cookie_users_url
    assert_equal admin, current_user
  end

  # a request from another tab that read the session before impersonating writes it back afterwards
  def test_cookie_store_stale_session
    User.create!(name: "Admin")
    user = User.create!(name: "User")
    session_key = Rails.application.config.session_options[:key]

    get cookie_users_url
    stale_session = cookies[session_key]
    post impersonate_cookie_user_url(user.id)
    cookies[session_key] = stale_session

    get cookie_users_url
    assert_equal user, current_user
  end

  def test_cookie_store_different_true_user
    admin = User.create!(name: "Admin")
    user = User.create!(name: "User")

    post impersonate_cookie_user_url(user.id)
    admin.update!(name: "Previous Admin")
    other_admin = User.create!(name: "Admin")

    get cookie_users_url
    assert_equal other_admin, current_user
  end

  private

  def current_user
    controller.current_user
  end

  def true_user
    controller.true_user
  end
end
