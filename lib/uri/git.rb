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
  @@schemes["GIT"] = Git
end
