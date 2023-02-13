# Consul K8s Scripts

## Dev Environment Setup
### Build New Consul/Consul-K8s Images
* Start Docker Desktop and log into dockerhub
* Start Kind cluster `kind create cluster`
* Run ./build-update-values.sh to build latest Consul and Consul-K8s Control-Plane, push them to dockerhub and then update the SHAs in the `values.yaml`

### Setup Enterprise
* Run 
```shell
secret=$(cat ../license/license.txt)
kubectl create secret generic consul-ent-license --from-literal="key=${secret}"
````

### Installing using helm
```bash
helm install consul -f values.yaml ~/dev/consul-k8s/charts/consul
```

### Installing CRDs
Example: kubectl apply -f serviceDefault.yaml

#### Validating CRD
After successfully installing the CRD
1. Validate webhook validation
2. Confirm that the CRD is synced
3. Check Consul for config entry
```bash
kubectl exec consul-server-0 -- consul config read -kind service-defaults -name global
```

### Cleanup
1. Cleanup any created resource, otherwise you have to run the next step and re-create twice becuase the resources will not be deleted during a `helm delete`, they get deleted during the subsequent `helm install`
2. Run `helm delete` .zsh defined script:
```bash
hdel consul
```



