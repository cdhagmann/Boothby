# frozen_string_literal: true

require_relative "lib/boothby/version"

Gem::Specification.new do |spec|
  spec.name = "boothby"
  spec.license= "MIT"
  spec.version = Boothby::VERSION
  spec.authors = ["Christopher Hagmann"]
  spec.email = ["cdhagmann@gmail.com"]

  spec.summary = "Groundskeeper to manage your rails application"
  spec.description = "Groundskeeper to manage your rails application"
  spec.homepage = "https://cdhagmann.com/Boothby"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cdhagmann/Boothby"
  spec.metadata["changelog_uri"] = "https://cdhagmann.com/Boothby/CHANGELOG.html"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "thor"
  spec.add_dependency "pastel"
  spec.add_dependency "tty-spinner"
  spec.add_dependency "tty-command"
  spec.add_dependency "rails", ">= 5.2"

  spec.add_development_dependency 'pry'
  spec.add_development_dependency "rspec"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
