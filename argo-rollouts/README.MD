# Usage
This is for building and testing argo rollout integrations with Consul

# How to Run a Test
Everything uses make targets and the local makefile
1. Update any of the necessary variables
2. Install a consul-enterprise license to `secrets` directory at the root of the project and name it `consul_license.txt`
3. Run `make setup` to start kind and install Consul/Consul-K8s for you
4. Run `make argo` to build and deploy argo along with any necessary CRDs. Argo gets installed to the 
4. Run `make rollout-watch` to watch the deployments
5. Run `make deploy-canary-1` to deploy a canary deployment
6. Run `make promote` to promote the canary deployment and watch it succeed