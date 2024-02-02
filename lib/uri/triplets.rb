# frozen_string_literal: true

require "uri"

# Triplets is a mix-in for subclasses of URI::Generic, which
# allows URI to use SCP-style Triplet URLs in a somewhat more
# meaningful way.
module Triplets
  attr_accessor :scheme, :user, :host, :path

  # @return [String] a string representation of the URI components
  # as an SCP-style Triplet
  def triplet
    str = []
    str << "#{user}@" if user && !user.empty?
    str << "#{host}:#{path}".squeeze("/")
    str.join
  end
  private :triplet

  # @return [String] a string representation of the URI components
  # as a valid RFC compliant URI
  # rubocop:disable Metrics/AbcSize
  def rfc_uri
    str = []
    str << "#{scheme}://" if scheme
    str << "#{user}@" if user
    if port && port != self.class::DEFAULT_PORT
      host_info = [host, port].join(":")
      str << [host_info, path].join("/").squeeze("/")
    else
      str << [host, path].join("/").squeeze("/")
    end
    str.join
  end
  private :rfc_uri
  # rubocop:enable Metrics/AbcSize

  def to_s
    return triplet if triplet?

    rfc_uri
  end

  # Use the same regular expressions that the parser uses to determine
  # if this is a valid triplet.
  def triplet?
    # False if self matches a normal URI scheme
    rfc_uri !~ URI.parser.const_get(:TI_SCHEME) &&
      # False unless self matches a Triplet scheme
      !!(triplet =~ URI.parser.const_get(:TI_TRIPLET))
  end
end

# A SCP Triplet is *not* a canonical URI. It doesn't follow any RFCs that
# I've been able to find, and it's difficult to reason about if you
# try to force it into a URI::Generic as-is. TripletInterruptus provides
# helper methods that preserve the upstream behavior of URI::Generic
# but extend it just enough that it doesn't choke on SCP Triplets if
# they're passed.
module TripletInterruptus
  # Determine if a string can be teased apart into URI-like components
  TI_TRIPLET = %r{\A(?:(?<userinfo>.+)@+)?(?<host>[\w.-]+):(?<path>.*)\z}.freeze

  # Determine if a string is prefixed with a URI scheme like http:// or ssh://
  TI_SCHEME = %r{\A(?:(?<scheme>[a-z]+)://)}.freeze

  def parse(uri)
    return build_triplet(uri) if triplet?(uri)

    super(uri)
  end

  def split(uri)
    return super(uri) unless triplet?(uri)

    parts = parse_triplet(uri)
    [nil, parts[:userinfo], parts[:host], nil,
     nil, parts[:path], nil, nil, nil]
  end

  def triplet?(address)
    address.match(TI_TRIPLET) && !address.match(TI_SCHEME)
  end

  def build_triplet(address)
    values = parse_triplet(address)
    return nil unless values

    URI.scheme_list[URI.default_triplet_type].build(values)
  end
  private :build_triplet

  def parse_triplet(address)
    parts = address.match(TI_TRIPLET)
    return nil unless parts

    parts.names.map(&:to_sym).zip(parts.captures).to_h
  end
  private :parse_triplet
end

module TripletHandling
  TRIPLET_CLASSES = %w[Git SCP SSH].freeze

  def self.included(base)
    base.extend(TripletHandling)
  end

  def default_triplet_type
    @default_triplet_type ||= "SSH"
  end

  def default_triplet_type=(value)
    raise ArgumentError, "'#{value}' is not one of: #{TRIPLET_CLASSES.join(', ')}" unless TRIPLET_CLASSES.include?(value)

    @default_triplet_type = value
  end

  def parser
    return URI::RFC3986_Parser if
      Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.2.0")

    URI::Parser
  end
end

# Reopen URI and include TripletHandling (which will then
# extend URI to add triplet-specific class methods).
module URI
  include TripletHandling
end

module URI
  # Reopen URI::Parser and prepend TripletInterruptus. This
  # allows us to hook into URI::Parser.parse and attempt to
  # parse a triplet before URI::Parser can reject it. Otherwise
  # fall through to the original URI::Parser.parse method.
  #
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.2.0")
    # rubocop:disable Naming/ClassAndModuleCamelCase
    class RFC3986_Parser
      prepend TripletInterruptus
    end
    # rubocop:enable Naming/ClassAndModuleCamelCase
  else
    class Parser
      prepend TripletInterruptus
    end
  end
end
