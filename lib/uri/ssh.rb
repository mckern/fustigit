require "uri/generic"

module URI
  class SSH < Generic
    include Triplets

    DEFAULT_PORT = 22

    COMPONENT = [
      :scheme,
      :userinfo,
      :host, :port, :path
    ].freeze
  end
  @@schemes["SSH"] = SSH
end
