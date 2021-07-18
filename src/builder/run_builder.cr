module Docr
  class RunCommandBuilder
    property image : String = ""
    property autoremove : Bool = false
    property name : String = ""
    property port_bindings = Hash(String, Array(Types::PortBinding)).new { |h, k| h[k] = [] of Types::PortBinding }
    property env = {} of String => String?
    property cmds : Array(String)?

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

    def env(name : String, val : String?)
      @env[name] = val
      self
    end

    def envs(envs : Hash(String, String?))
      @env = envs
      self
    end

    def cmd(cmd : String)
      unless @cmds
        @cmds = [] of String
      end
      @cmds.not_nil! << cmd
      self
    end

    def cmds(@cmds : Array(String))
      self
    end

    def port(host_port, container_port, host_ip = "127.0.0.1")
      @port_bindings[container_port] << Types::PortBinding.new(host_port: host_port, host_ip: host_ip)
      self
    end

    def execute
      config = Docr::Types::CreateContainerConfig.new(
        image: @image,
        env: @env.map { |n, v| "#{n}#{v.nil? ? "" : "=#{v}"}" },
        cmd: @cmds,
        host_config: Docr::Types::HostConfig.new(
          port_bindings: @port_bindings,
          auto_remove: @autoremove,
        ),
      )

      if @image.includes?(":")
        image, _, tag = @image.rpartition(":")
        @api.images.create(image, tag)
      else
        @api.images.create(@image)
      end

      cr = @api.containers.create(@name, config)
      @api.containers.start(cr.id)
      cr
    end
  end
end
