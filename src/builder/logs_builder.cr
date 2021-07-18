module Docr
  class LogsCommandBuilder
    property timestamps : Bool = false
    property tail : String = "all"
    property since : String? = nil
    property _until : String? = nil
    property name : String? = nil
    property stdout : Bool = true
    property stderr : Bool = true

    def initialize(@api : API)
    end

    def name(@name : String)
      self
    end

    def tail(tail : Int32)
      @tail = tail.to_s
      self
    end

    def until(@_until : String)
      self
    end

    def since(@since : String)
      self
    end

    def timestamps
      @timestamps = true
      self
    end

    def execute
      @api.containers.logs(@name.not_nil!, tail: @tail, stdout: @stdout, stderr: @stderr,
        since: @since, _until: @_until, timestamps: @timestamps)
    end
  end
end
