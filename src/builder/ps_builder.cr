module Docr
  class ProcessStatusBuilder
    def initialize(@api : API)
    end

    def execute
      summaries = @api.containers.list
    end
  end
end
