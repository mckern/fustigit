# frozen_string_literal: true

require "uri/generic"

module URI
  class SSH < Generic
    include Triplets

    DEFAULT_PORT = 22

    COMPONENT = %i[
      scheme
      userinfo
      host port path
    ].freeze
  end
  if respond_to? :register_scheme
    register_scheme "SSH", SSH
  else
    @@schemes["SSH"] = SSH
  end
end
