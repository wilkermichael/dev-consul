# Usage

## Setup
* Navigate to enterprise/ or oss/
* Edit the image/build.sh to match your environment
* If using enterprise copy a license (license.txt) to the license directory at the root of this repo

## Running
* run `make oss-image` or `make enterprise-image` if you need to build a new Consul image
* run the make target for the system/compose you want to bring up. Make targets are named after the directory with the docker-compose in it, for example `enterprise`
  * `make enterprise-down` to make sure everything is fresh (runs `docker-compose down` from the enterprise directory`)
  * `make enterprise` to bring up the system (runs `docker-compose up` and `peer.sh` from the enterprise directory)

# Talking to a service
* A service runs on exposed port 9001, this allows you to connect to the cluster
* Service includes an api:
  * / -> responds with 'Hi' and the address (useful if using forwarding)
  * /forward -> allows you to forward to another service
    * Query Params:
      * addr -> set to the address of the service to be forwarded to
  * /err -> causes the service to error
    * Useful for testing failover and other error scenarios
