module Docr
  class RunCommandBuilder
    property image : String = ""
    property autoremove : Bool = false
    property name : String = ""
    property port_bindings = Hash(String, Array(Types::PortBinding)).new { |h, k| h[k] = [] of Types::PortBinding }

    def initialize(@api : API)
    end

    def image(@image)
      self
    end

    def rm
      @autoremove = true
      self
    end

    def rm(@autoremove)
      self
    end

    def autoremove
      @autoremove = true
      self
    end

    def autoremove(@autoremove)
      self
    end

    def name(@name : String)
      self
    end

    def port(host_port, container_port, host_ip = "127.0.0.1")
      @port_bindings[container_port] << Types::PortBinding.new(host_port: host_port, host_ip: host_ip)
      self
    end

    def execute
      config = Docr::Types::CreateContainerConfig.new(
        image: @image,
        host_config: Docr::Types::HostConfig.new(
          port_bindings: @port_bindings,
          auto_remove: @autoremove,
        ),
      )

      cr = @api.containers.create(@name, config)
      @api.containers.start(cr.id)
    end
  end
end
