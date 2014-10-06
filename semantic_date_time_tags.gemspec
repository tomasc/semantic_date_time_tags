# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'semantic_date_time_tags/version'

Gem::Specification.new do |spec|
  spec.name          = "semantic_date_time_tags"
  spec.version       = SemanticDateTimeTags::VERSION
  spec.authors       = ["Tomas Celizna"]
  spec.email         = ["tomas.celizna@gmail.com"]
  spec.summary       = %q{Rails helpers for handling dates and time.}
  spec.description   = %q{Rails helpers for handling dates and time.}
  spec.homepage      = "https://github.com/tomasc/semantic_date_time_tags"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 4.1.0"

  # spec.add_development_dependency "i18n", "~> 0.5.0"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
end