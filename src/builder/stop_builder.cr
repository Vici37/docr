module Docr
  class StopCommandBuilder
    def initialize(@api : API)
    end

    def name(@name : String)
      self
    end

    def execute
      raise "Container name to stop undefined; use the `image` method to set it before calling execute" if @name.nil?

      name = @name.not_nil!

      @api.containers.stop(name)
    end
  end
end
