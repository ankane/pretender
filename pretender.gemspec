require_relative "lib/pretender/version"

Gem::Specification.new do |spec|
  spec.name          = "pretender"
  spec.version       = Pretender::VERSION
  spec.summary       = "Log in as another user in Rails"
  spec.homepage      = "https://github.com/ankane/pretender"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@chartkick.com"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.2"

  spec.add_dependency "actionpack", ">= 4.2"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "combustion"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "sqlite3"
end
