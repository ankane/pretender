# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pretender/version"

Gem::Specification.new do |spec|
  spec.name          = "pretender"
  spec.version       = Pretender::VERSION
  spec.authors       = ["Andrew Kane"]
  spec.email         = ["andrew@chartkick.com"]
  spec.description   = "Simple, powerful user impersonation for Rails"
  spec.summary       = "Easy to switch back and forth between roles, minimal code changes, and plays nicely with auditing tools"
  spec.homepage      = "https://github.com/ankane/pretender"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "actionpack"
  spec.add_dependency "activerecord", ">= 4"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
