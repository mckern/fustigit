# frozen_string_literal: true

require "bundler/setup"
require "minitest/spec"
require "minitest/autorun"
require "minitest/reporters"
require "json"

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    # exclude common Bundler locations
    %w[.bundle vendor].each { |dir| add_filter dir }
    # exclude test code
    add_filter "spec"
  end
end

def fixture(path)
  path = File.join(File.dirname(__FILE__), "fixtures", path)
  File.read(path)
end
