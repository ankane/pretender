require_relative "lib/pretender/version"

Gem::Specification.new do |spec|
  spec.name          = "pretender"
  spec.version       = Pretender::VERSION
  spec.summary       = "Log in as another user in Rails"
  spec.homepage      = "https://github.com/ankane/pretender"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.6"

  spec.add_dependency "actionpack", ">= 5.2"
end
