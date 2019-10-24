# frozen_string_literal: true

require "spec_helper"
require "fustigit"

describe URI do # rubocop:disable Metrics/BlockLength
  @git_repos = JSON.parse(fixture("formats.json"))
  @git_repos["URIs"].each do |protocol, repos|
    repos.each do |repo|
      describe %(#parse takes given URI "#{repo}") do
        it "returns URI::#{protocol}" do
          _(URI.parse(repo).is_a?(URI.const_get(protocol))).must_equal true
        end
      end
    end
  end

  @git_repos["paths"].each do |repo|
    describe %(#parse takes path "#{repo}") do
      it "returns URI::Generic" do
        _(URI.parse(repo).is_a?(URI::Generic)).must_equal true
      end
    end
  end

  @git_repos["triplets"].each do |repo|
    describe %(#parse takes triplet "#{repo}") do
      it "returns URI::#{URI.default_triplet_type}" do
        _(URI.parse(repo).is_a?(URI.const_get(URI.default_triplet_type))).must_equal true
      end

      it "recognizes URI::#{URI.default_triplet_type} as a triplet" do
        _(URI.parse(repo).triplet?).must_equal true
      end
    end
  end
end
