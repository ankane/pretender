class HomeController < ActionController::Base
  def index
    head :ok
  end

  def impersonate
    impersonate_user(User.find_by!(name: "User"))
    head :ok
  end

  def stop_impersonating
    stop_impersonating_user
    head :ok
  end

  def current_user
    @current_user ||= User.find_by!(name: "Admin")
  end
  impersonates :user
end
