# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collector/version'

Gem::Specification.new do |spec|
  spec.name          = "collector-ruby"
  spec.version       = Collector::VERSION
  spec.authors       = ["Felix Holmgren"]
  spec.email         = ["felix.holmgren@gmail.com"]
  spec.description   = %q{Client for the Collector API}
  spec.summary       = %q{Just starting out}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "virtus", ">= 0.5.0"
  spec.add_runtime_dependency "representable"
  spec.add_runtime_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13"
  spec.add_development_dependency "require_all"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
end
