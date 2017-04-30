## WAT

This should offer a recent build of SUSE/portus for docker use. Source will not be modified or hacked and is cloned directly from [SUSE/portus](https://github.com/SUSE/Portus) during the build, so releases never getting delayed due to merge issues.

This image is specifically designed to be configurable and also used in a rancher catalog like this one [catalog](https://github.com/EugenMayer/kontextwork-catalog/tree/master/templates/registry-slim)

Docker images are published to [hub.docker.io](https://hub.docker.com/r/eugenmayer/portus/)

## Credits

Currently [zaggash](https://github.com/zaggash) is the main maintainer, so please give him the credits. Thanks for taking this image to the next level!

## Configuration
### registry

The registry is configured using ENV variables, even if not officially documented ( only config.yml is documents ) it is supported, see  we can use environment variables to configure registry, see https://github.com/docker/distribution/blob/master/configuration/configuration.go#L13

## Changes to SUSE/ports

- adding a new rake task to pre-install a registry, should be removed when https://github.com/SUSE/Portus/issues/1036 is finished
- adding a startup script for docker

## Releases

For now, only planed to be published on [hub.docker.io](https://hub.docker.com/r/eugenmayer/portus/)

## Test

Checkout the repo, enter run

```
cd ./test 
./start.sh
```

You need to add portus.dev and registry.dev to your /etc/hosts file and point it to your docker or docker-machine ip ( as usual )

Its just a docker-compose wrapper to deal with timing during startup without "really" caring about it.
A docker-compose file with pre-defined configuration values is used and when done, you can access your portus / registry by

```
https://portus.dev
https://registry.dev
```

You can login with docker

```
docker login registry.dev
```

## Build

```
cd make
make build
```
