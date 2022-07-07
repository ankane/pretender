require_relative "test_helper"

class PretenderTest < ActionDispatch::IntegrationTest
  def setup
    User.delete_all
    CustomerFake.delete_all
    Account.delete_all
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

  def test_non_matching_class_works
    admin = CustomerFake.create!(name: "Admin")
    user = CustomerFake.create!(name: "User")

    get customer_url
    assert_response :success

    assert_equal admin, current_customer
    assert_equal admin, true_customer

    post impersonate_customer_url
    assert_response :success

    assert_equal user, current_customer
    assert_equal admin, true_customer

    post stop_impersonating_customer_url
    assert_response :success

    assert_equal admin, current_customer
    assert_equal admin, true_customer
  end

  def test_session_works
    admin = User.create!(name: "Admin")
    user = User.create!(name: "User")

    get root_url
    assert_response :success

    assert_equal admin, current_user
    assert_equal admin, true_user

    post setup_session_url
    assert_response :success

    assert_equal user, current_user
    assert_equal admin, true_user
  end

  def test_old_style_with_statements
    admin = Account.create!(name: "Admin")
    user = Account.create!(name: "User")

    get customer_url
    assert_response :success

    assert_equal admin, current_account
    assert_equal admin, true_account

    post impersonate_custom_with_url
    assert_response :success

    assert_equal user, current_account
    assert_equal admin, true_account
  end

  private

  def current_user
    controller.current_user
  end

  def true_user
    controller.true_user
  end

  def current_customer
    controller.current_customer
  end

  def true_customer
    controller.true_customer
  end

  def current_account
    controller.current_account
  end

  def true_account
    controller.true_account
  end
end
