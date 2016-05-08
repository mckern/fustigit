require "uri/generic"

module URI
  class SCP < Generic
    include Triplets

    DEFAULT_PORT = 22

    COMPONENT = [
      :scheme,
      :userinfo,
      :host, :port, :path
    ].freeze
  end
  @@schemes["SCP"] = SCP
end
