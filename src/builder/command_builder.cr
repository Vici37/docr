require "../types/**"
require "./run_builder"
require "./stop_builder"
require "./logs_builder"
require "./rm_builder"

module Docr
  # Helper method to start a command. This is to help _somewhat_ mimic the docker cli command and hide
  # away the need to know the docker API specific names to do things.
  #
  # ```
  # Docr.command.run
  #   .image("alpine:latest")
  #   .rm # (or .autoremove)
  #   .name("mycontainer")
  #   .port("8080/tcp", "8080")
  #   .execute
  # ```
  def self.command
    CommandBuilder.new(API.new)
  end

  class CommandBuilder
    def initialize(@api : API)
    end

    def run
      RunCommandBuilder.new(@api)
    end

    def ps
      ProcessStatusBuilder.new(@api)
    end

    def stop
      StopCommandBuilder.new(@api)
    end

    def logs
      LogsCommandBuilder.new(@api)
    end

    def rm
      RmCommandBuilder.new(@api)
    end
  end
end
