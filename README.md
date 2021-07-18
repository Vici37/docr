# docr

![CI](https://github.com/marghidanu/docr/workflows/CI/badge.svg)

Docker client for Crystal. 

Full API description can be found [here](https://docs.docker.com/engine/api/v1.41/)

## Description

Remaining issues:

* [ ] Test all endpoint functions
* [ ] Make sure models are complete
* [ ] Extend client to support calls over network

PRs are always welcomed!

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     docr:
       github: marghidanu/docr
   ```

2. Run `shards install`

## Usage

```crystal
require "docr"

# Interacting with docker engine can be done through the docker engine API client, or a
# (considerably less feature rich for now) commands interface that models more closely
# the docker cli.

# API example
api = Docr::API.new

# downloads the image, second argument can be used to specify tag
api.images.create("alpine")

config = Docr::Types::CreateContainerConfig.new(
  image: "alpine:latest",
  env: ["ENVVAR=one"],
  host_config: Docr::Types::HostConfig.new(
    auto_remove: true
  )
)

api.containers.create("my-alpine-container", config)
api.containers.start("my-alpine-container")

# stop the container
api.containers.stop("my-alpine-container")

# delete the container (if auto_remove isn't true)
api.containers.delete("my-alpine-container")

# Command example
# All commands follow the builder pattern, with each intermediate call just adding configurations,
# and the `execute` method "building" and running the actual call.
Docr.commands.run
  .image("alpine:latest")
  .env("ENVVAR", "one")
  .name("my-alpine-container")
  .rm # or .auto_remove
  .execute

# stop the container
Docr.commands.stop
  .name("my-alpine-container")
  .execute

# delete the container (if auto_remove isn't true)
Docr.commands.rm
  .name("my-alpine-container")
  .execute
```

## Supported API calls

### Containers

* [x] ContainerList
* [x] ContainerCreate
* [x] ContainerInspect
* [x] ContainerTop
* [x] ContainerLogs
* [x] ContainerChanges
* [ ] ContainerStats
* [x] ContainerStart
* [x] ContainerStop
* [x] ContainerRestart
* [x] ContainerKill
* [ ] ContainerUpdate
* [ ] ContainerRename
* [x] ContainerPause
* [x] ContainerUnpause
* [ ] ContainerAttach
* [x] ContainerWait
* [x] ContainerDelete

### Images

* [x] ImageList
* [ ] ImageBuild
* [x] ImageCreate
* [x] ImageInspect
* [x] ImageHistory
* [x] ImagePush
* [x] ImageTag
* [x] ImageDelete

### Networks

* [x] NetworkList
* [x] NetworkCreate
* [x] NetworkInspect
* [ ] NetworkConnect
* [ ] NetworkDisconnect
* [x] NetworkDelete

### Volumes

* [x] VolumeList
* [x] VolumeCreate
* [x] VolumeInspect
* [x] VolumeDelete

### Exec

* [x] ContainerExec
* [x] ExecStart
* [x] ExecInspect

### System

* [x] SystemAuth
* [x] SystemInfo
* [x] SystemVersion
* [x] SystemPing
* [x] SystemEvents
* [ ] SystemDataUsage

## Contributors

- [Tudor Marghidanu](https://github.com/marghidanu) - creator and maintainer
- [Troy Sornson](https://github.com/Vici37) - contributor