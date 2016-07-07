require "uri"

# Triplets is a mix-in for subclasses of URI::Generic, which
# allows URI to use SCP-style Triplet URLs in a somewhat more
# meaningful way.
module Triplets
  attr_accessor :scheme, :user, :host, :path

  # @return [String] a string representation of the URI components
  # as an SCP-style Triplet
  def triplet
    str = ""
    str << "#{user}@" if user && !user.empty?
    str << "#{host}:#{path}".squeeze("/")
  end
  private :triplet

  # @return [String] a string representation of the URI components
  # as a valid RFC compliant URI
  # rubocop:disable Metrics/AbcSize
  def rfc_uri
    str = ""
    str << "#{scheme}://" if scheme
    str << "#{user}@" if user
    if port && port != self.class::DEFAULT_PORT
      host_info = [host, port].join(":")
      str << [host_info, path].join("/").squeeze("/")
    else
      str << [host, path].join("/").squeeze("/")
    end
  end
  private :rfc_uri

  # if self.path is a relative path, assume that this was parsed
  # as a triplet and return a Triplet. Otherwise, assume that
  # this is a valid URI and print an RFC compliant URI. This
  # may not be the most robust method of determining if a
  # triplet should be used, but everything starts someplace.
  def to_s
    return triplet if triplet?
    rfc_uri
  end

  # Use the same regular expressions that the parser
  def triplet?
    triplet.match(URI.parser.const_get(:TRIPLET)) &&
      !rfc_uri.match(URI.parser.const_get(:SCHEME))
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
  TRIPLET = %r{\A(?:(?<userinfo>.+)[@]+)?(?<host>[\w.]+):(?<path>.*)\z}

  # Determine if a string is prefixed with a URI scheme like http:// or ssh://
  SCHEME = %r{\A(?:(?<scheme>[a-z]+)://)}

  def parse(uri)
    return build_triplet(uri) if triplet?(uri)
    super(uri)
  end

  def triplet?(address)
    address.match(TRIPLET) && !address.match(SCHEME)
  end

  def build_triplet(address)
    values = parse_triplet(address)
    return nil unless values
    URI.scheme_list[URI.default_triplet_type].build(values)
  end
  private :build_triplet

  def parse_triplet(address)
    parts = address.match(TRIPLET)
    return nil unless parts
    Hash[parts.names.map(&:to_sym).zip(parts.captures)]
  end
  private :parse_triplet
end

module TripletHandling
  TRIPLET_CLASSES = %w(Git SCP SSH).freeze

  def self.included(base)
    base.extend(TripletHandling)
  end

  def default_triplet_type
    @default_triplet_type ||= "SSH"
  end

  def default_triplet_type=(value)
    unless TRIPLET_CLASSES.include?(value)
      raise ArgumentError, "'#{value}' is not one of: #{TRIPLET_CLASSES.join(', ')}"
    end
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
    # rubocop:disable Style/ClassAndModuleCamelCase
    class RFC3986_Parser
      prepend TripletInterruptus
    end
  else
    class Parser
      prepend TripletInterruptus
    end
  end
end
