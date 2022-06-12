# frozen_string_literal: true

require "uri/generic"

module URI
  class SCP < Generic
    include Triplets

    DEFAULT_PORT = 22

    COMPONENT = %i[
      scheme
      userinfo
      host port path
    ].freeze
  end
  if respond_to? :register_scheme
    register_scheme "SCP", SCP
  else
    @@schemes["SCP"] = SCP
  end
end
