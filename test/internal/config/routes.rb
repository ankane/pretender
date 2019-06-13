Rails.application.routes.draw do
  root "home#index"
  post "impersonate" => "home#impersonate"
  post "stop_impersonating" => "home#stop_impersonating"
end
