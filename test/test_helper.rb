require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "combustion"

Combustion.path = "test/internal"
Combustion.initialize! :active_record do
  config.load_defaults Rails::VERSION::STRING.to_f
end

# https://github.com/rails/rails/issues/54595
if RUBY_ENGINE == "jruby" && Rails::VERSION::MAJOR >= 8
  Rails.application.reload_routes_unless_loaded
end
