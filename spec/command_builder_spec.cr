require "./spec_helper"
require "uuid"

describe Docr::CommandBuilder do
  it "starts, lists, and stops containers" do
    original_containers = Docr.command.ps.execute

    name = UUID.random.to_s

    Docr.command.run
      .image("nginx:latest")
      .name(name)
      .rm
      .execute

    containers = Docr.command.ps.execute

    containers.size.should eq original_containers.size + 1
    nginx = (containers - original_containers)[0]
    nginx.names.should contain "/#{name}"
    nginx.image.should eq "nginx:latest"
    nginx.state.should eq "running"

    Docr.command.stop.name(name).execute
    sleep 2 # Let docker daemon have time to kill the image

    containers = Docr.command.ps.execute
    containers.size.should eq original_containers.size
  end

  it "supports env vars and custom commands" do
    name = UUID.random.to_s

    Docr.command.run
      .image("alpine:latest")
      .name(name)
      .cmds(["/bin/sh", "-c", "echo $TEST"])
      .env("TEST", "this is a test")
      .execute

    logsio = Docr.command.logs
      .name(name)
      .execute

    logs = logsio.gets_to_end
    logs[8..-1].strip.should eq "this is a test"

    Docr.command.rm.name(name).execute
  end
end
