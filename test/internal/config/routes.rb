Rails.application.routes.draw do
  root "home#index"
  post "impersonate" => "home#impersonate"
  post "setup_session" => "home#setup_session"
  post "stop_impersonating" => "home#stop_impersonating"

  get "customer", to: "customer#index"
  post "impersonate_customer" => "customer#impersonate"
  post "stop_impersonating_customer" => "customer#stop_impersonating"
  post "impersonate_custom_with" => "customer#impersonate_custom_with"
end
