class HomeController < ActionController::Base
  def index
    head :ok
  end

  def impersonate
    impersonate_user(User.last)
    head :ok
  end

  def stop_impersonating
    stop_impersonating_user
    head :ok
  end

  def current_user
    @user ||= User.first
  end
  impersonates :user
end
