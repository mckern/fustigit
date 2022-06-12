# frozen_string_literal: true

require "uri/generic"

module URI
  class RSYNC < Generic
    DEFAULT_PORT = 873
  end
  if respond_to? :register_scheme
    register_scheme "RSYNC", RSYNC
  else
    @@schemes["RSYNC"] = RSYNC
  end
end
