# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'racing/sprockets/version'

Gem::Specification.new do |spec|
  spec.name          = "racing-sprockets"
  spec.version       = Racing::Sprockets::VERSION
  spec.authors       = ["Craig McNamara"]
  spec.email         = ["craig@caring.com"]
  spec.description   = %q{Try to speed up configuration and deployment of Sprockets}
  spec.summary       = %q{Compiles assets in parallel with a thread pool. Provides Jammit like precompile config as assets.yml}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thread'
  spec.add_dependency 'thread_safe'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
