# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collector/version'

Gem::Specification.new do |spec|
  spec.name          = 'collector-ruby'
  spec.version       = Collector::VERSION
  spec.authors       = ['Felix Holmgren']
  spec.email         = ['felix.holmgren@gmail.com']
  spec.description   = 'Client for the Collector API'
  spec.summary       = 'Just starting out'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'virtus', '>= 0.5.0'
  spec.add_runtime_dependency 'representable', '~> 2.4.1'
  spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.13'
  spec.add_development_dependency 'require_all'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'commander'
  spec.add_development_dependency 'terminal-table'
  spec.add_development_dependency 'rubocop'
end
