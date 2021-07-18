module Docr
  class ProcessStatusBuilder
    def initialize(@api : API)
    end

    def execute
      @api.containers.list
    end
  end
end
