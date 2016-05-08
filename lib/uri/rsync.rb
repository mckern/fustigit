require "uri/generic"

module URI
  class RSYNC < Generic
    DEFAULT_PORT = 873
  end
  @@schemes["RSYNC"] = RSYNC
end
