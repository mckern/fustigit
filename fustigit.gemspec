# frozen_string_literal: true

require "time"
require File.join(File.dirname(__FILE__), "lib", "fustigit", "version")

Gem::Specification.new do |gem|
  gem.name = "fustigit"
  gem.version = Fustigit::Version::VERSION
  gem.date = Date.today.to_s

  gem.summary = %(Use URI to "parse" SCP-like triplets)
  gem.description = %("Parse" SCP-like address triplets with the Standard Ruby URI Library.)
  gem.license = "Apache-2.0"

  gem.authors = ["Ryan McKern"]
  gem.email = "ryan@orangefort.com"
  gem.homepage = "http://github.com/mckern/fustigit"
  gem.specification_version = 3
  gem.required_ruby_version = ">= 2.5.0"

  gem.require_path = "lib"

  gem.files = Dir["lib/**/*.rb", "CHANGELOG.md", "README.md", "LICENSE"]
  gem.test_files = Dir["Rakefile", "spec/**/*.rb"]
end
