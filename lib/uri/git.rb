# frozen_string_literal: true

require "uri/generic"

module URI
  class Git < Generic
    include Triplets

    DEFAULT_PORT = 9418
    USE_REGISTRY = false

    COMPONENT = %i[
      scheme
      userinfo
      host port path
    ].freeze
  end
  if respond_to? :register_scheme
    register_scheme "GIT", Git
  else
    @@schemes["GIT"] = Git
  end
end
