class CustomerController < ActionController::Base
  def index
    head :ok
  end

  def impersonate
    impersonate_customer(CustomerFake.find_by!(name: "User"))
    head :ok
  end

  def impersonate_custom_with
    impersonate_account(Account.find_by!(name: "User"))
  end

  def stop_impersonating
    stop_impersonating_customer
    stop_impersonating_account
    head :ok
  end

  def current_customer
    @current_customer ||= CustomerFake.find_by!(name: "Admin")
  end

  def current_account
    @current_account ||= Account.find_by!(name: "Admin")
  end

  impersonates :customer
  impersonates :account, with: ->(id) { Account.find_by(id: id) }
end
