# frozen_string_literal: true

require_relative "lib/semantic_date_time_tags/version"

Gem::Specification.new do |spec|
  spec.name = "semantic_date_time_tags"
  spec.version = SemanticDateTimeTags::VERSION
  spec.authors = [ "Tomas Celizna" ]
  spec.email = [ "mail@tomascelizna.com" ]

  spec.summary = "Rails helpers for handling dates and time."
  spec.description = "Rails helpers for handling dates and time."
  spec.homepage = "https://github.com/tomasc/semantic_date_time_tags"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/tomasc/semantic_date_time_tags/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = [ "lib" ]

  spec.add_dependency "rails"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_development_dependency "lefthook"
  spec.add_development_dependency "rubocop-rails-omakase"
end
