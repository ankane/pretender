require_relative "test_helper"

module TheTruth
  def test_original_state
    @controller.current_user = @impersonator

    assert_equal @impersonator, @controller.true_user
    assert_equal @impersonator, @controller.current_user
  end

  def test_impersonates
    @controller.current_user = @impersonator
    @controller.impersonate_user @impersonated

    assert_equal @impersonator, @controller.true_user
    assert_equal @impersonated, @controller.current_user
  end

  def test_impersonated_state
    @controller.current_user = @impersonator
    @controller.session[:impersonated_user_id] = @impersonated.id

    assert_equal @impersonator, @controller.true_user
    assert_equal @impersonated, @controller.current_user
  end

  def test_stops_impersonating
    @controller.current_user = @impersonator
    @controller.session[:impersonated_user_id] = @impersonated.id
    @controller.stop_impersonating_user

    assert_equal @impersonator, @controller.true_user
    assert_equal @impersonator, @controller.current_user
  end
end

class PretenderTest < Minitest::Test
  include TheTruth

  def setup
    @impersonator = User.new("impersonator")
    @impersonated = User.new("impersonated")
    @controller = ApplicationController.new
  end
end

class SuperPretenderTest < Minitest::Test
  include TheTruth

  def setup
    @impersonator = User.new("impersonator")
    @impersonated = User.new("impersonated")
    @controller = ApplicationController.new
    class << @controller
      def current_user
        super
      end
    end
  end
end
