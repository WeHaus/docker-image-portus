## WAT

This should offer a recent build of SUSE/portus for docker use. Source will not be modified or hacked, so releases never getting delayed due to merge issues.

This was on of the motivation to fork from [sshipway/Portus](https://github.com/sshipway/Portus) - due to the hacks, the builds are outdated, but also some missing features.

This work is specifically build to be configureable and also used in a rancher catalog this [catalog](https://github.com/EugenMayer/kontextwork-catalog/tree/master/templates/registry-slim)

Docker images will be published on [hub.docker.io](https://hub.docker.com/r/eugenmayer/portus/)

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