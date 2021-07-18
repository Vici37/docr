module Docr
  class RmCommandBuilder
    @name : String? = nil
    @force : Bool = false
    @volumes : Bool = false
    @link : String? = nil

    def initialize(@api : API)
    end

    def name(@name : String)
      self
    end

    def force
      @force = true
      self
    end

    def volumes
      @volumes = true
      self
    end

    def link(@link : String)
      self
    end

    def execute
      raise "Removing containers requires a name to be specified" if @name.nil?
      @api.containers.delete(@name.not_nil!, @volumes, @force, @link)
    end
  end
end
