# Usage

## Setup
* Navigate to enterprise/ or oss/
* Edit the image/build.sh to match your environment
* If using enterprise copy a license (license.txt) to the license directory at the root of this repo

## Running
* go to the root dir
* run `./build-image.sh oss` or `./build-image.sh enterprise` if you need to build a new Consul image
* run
  * docker compose down to delete the old env
  * docker compose up to create a new one
* run ./peer.sh in the OSS or Enterprise directory to setup the peering connections

# Talking to a service
* A service runs on exposed port 9001, this allows you to connect to the cluster
* Service includes an api:
  * / -> responds with 'Hi' and the address (useful if using forwarding)
  * /forward -> allows you to forward to another service
    * Query Params:
      * addr -> set to the address of the service to be forwarded to
  * /err -> causes the service to error
    * Useful for testing failover and other error scenarios
