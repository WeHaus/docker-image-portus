## WAT

This should offer a recent build of SUSE/portus for docker use. Source will not be modified or hackedand is cloned directly from [SUSE/portus](https://github.com/SUSE/Portus) during the build, so releases never getting delayed due to merge issues.

This motivation was the reason to fork from [sshipway/Portus](https://github.com/sshipway/Portus) great work - due to the 'hacks' he made, the builds are outdated, but also important features are missing.

This image is specifically designed to be configureable and also used in a rancher catalog like this one [catalog](https://github.com/EugenMayer/kontextwork-catalog/tree/master/templates/registry-slim)

Docker images will be published on [hub.docker.io](https://hub.docker.com/r/eugenmayer/portus/)

## Configuration
### registry

The registry is configured using ENV variables, even if not officially documented ( only config.yml is documents ) it is supported, see  we can use environment variables to configure registry, see https://github.com/docker/distribution/blob/master/configuration/configuration.go#L13

## Changes to SUSE/ports

- addind a new rake task to pre-install a registry
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
A docker-compose file with pre-defined configuraiton values is used and when done, you can access your portus / registry by

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
