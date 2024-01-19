# Usage
This is for building custom versions of Consul-K8s for various support reasons. Most of the setup assumes that an older version of Consul-K8s is running, but with some enhancements this could be used for newer versions. Everything can be run from the makefile

## MAKEFILE
The makefile contains 3 sections, building, testing and upgrade testing

### Building
To build a new custom image run `make build-and-verify` this will
1. Update any of the necessary variables
2. Build a combo image of amd64 and arm64 Consul-K8s using `docker manifest`
3. Verify that the version and architecture for each sub image is correct

### General Testing
1. Update any of the necessary variables
2. Install a consul-enterprise license to `secrets` directory at the root of the project and name it `consul_license.txt` 
3. Run `make update-values-yaml` to update images in the `values.yaml` file with built images/target Consul image
4. Run `make setup` which will create a kind cluster, load a secret and then install Consul/Consul-K8s for you
5. Witness that everything starts up correctly
6. Run `make acceptance-connect-test` to run the connect acceptance tests, and verify these all pass

### Upgrade Testing
1. Run `make deploy-old` to deploy the old version of Consul-K8s. Verify this starts correctly.
2. Run `make apply-crd` to install a CRD
3. Run `make verify-crd` to print out the Consul and K8s config-entry/CRD and visually confirm that these exist
4. Run `make upgrade` to upgrade to the built image. Verify this starts correctly
5. Run `make verify-crd` to print out the Consul and K8s config-entry/CRD and visually confirm that these exist
6. Run `make rollback` to rollback to the old image. Verify this starts correctly
7. Run `make verify-crd` to print out the Consul and K8s config-entry/CRD and visually confirm that these exist

