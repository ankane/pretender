class UsersController < ApplicationController
  def index
    head :ok
  end

  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    head :ok
  end

  def stop_impersonating
    stop_impersonating_user
    head :ok
  end
end
