require "./spec_helper"

api = Docr::API.new

api.images.create("nginx", "latest")

describe "Containers" do
  it "should create a new container" do
    config = Docr::Types::CreateContainerConfig.new(
      image: "nginx:latest",
      host_config: Docr::Types::HostConfig.new,
    )

    _ = api.containers.create("abc", config)
    api.containers.start("abc")
  end

  it "should inspect container" do
    result = api.containers.inspect("abc")

    result.should_not be_nil
    result.name.should eq "/abc"
  end

  it "should display running processes inside the container" do
    _ = api.containers.top(id: "abc", ps_args: "aux")
  end

  it "should list all containers" do
    result = api.containers.list(
      limit: 1,
      filters: {"name" => ["abc"]},
    )

    result.empty?.should be_false

    result[0].image.should eq "nginx:latest"
    result[0].names.includes?("/abc").should be_true
  end

  it "should delete the container" do
    api.containers.stop("abc")
    api.containers.delete("abc")

    result = api.containers.list(
      limit: 1,
      filters: {"name" => ["abc"]},
    )

    result.empty?.should be_true
  end

  it "create and run the container" do
    api.containers.run(
      name: "abc_running",
      image: "nginx:latest",
      auto_remove: true)

    api.containers.list(limit: 1, filters: {"name" => ["abc_running"]}).size.should eq 1

    api.containers.stop("abc_running")
    # Need to wait long enough for the pod to be deleted (auto_removed)
    sleep(1)

    api.containers.list(limit: 1, filters: {"name" => ["abc_running"]}).size.should eq 0
  end
end
