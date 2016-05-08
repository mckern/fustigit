require "spec_helper"
require "fustigit"

describe URI do
  @git_repos = JSON.load(fixture("formats.json"))
  @git_repos["URIs"].each do |protocol, repos|
    repos.each do |repo|
      describe %(#parse takes given URI "#{repo}") do
        it "returns URI::#{protocol}" do
          URI.parse(repo).is_a?(URI.const_get(protocol)).must_equal true
        end
      end
    end
  end

  @git_repos["paths"].each do |repo|
    describe %(#parse takes path "#{repo}") do
      it "returns URI::Generic" do
        URI.parse(repo).is_a?(URI::Generic).must_equal true
      end
    end
  end

  @git_repos["triplets"].each do |repo|
    describe %(#parse takes triplet "#{repo}") do
      it "returns URI::#{URI.default_triplet_type}" do
        URI.parse(repo).is_a?(URI.const_get(URI.default_triplet_type)).must_equal true
      end
    end
  end
end
