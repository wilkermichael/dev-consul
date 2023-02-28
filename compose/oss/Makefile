.PHONY: start
start:
	docker-compose up -d

.PHONY: stop
stop:
	docker-compose down

.PHONY: follow
follow:
	while true; do docker-compose logs --follow --tail=0; sleep 2; done

.PHONY: follow-dc1s1
follow-dc1s1:
	while true; do docker-compose logs --follow --tail=0 dc1s1; sleep 2; done

.PHONY: follow-dc1igw1
follow-dc1igw1:
	while true; do docker-compose logs --follow --tail=0 dc1igw1; sleep 2; done

.PHONY: follow-dc1igw1
follow-dc1svc1:
	while true; do docker-compose logs --follow --tail=0 dc1svc1; sleep 2; done

.PHONY: shell-dc1s1
shell-dc1s1:
	docker-compose exec dc1s1 /bin/bash

.PHONY: shell-dc1igw1
shell-dc1igw1:
	docker-compose exec dc1igw1 /bin/bash

.PHONY: shell-dc1svc1
shell-dc1svc1:
	docker-compose exec dc1svc1 /bin/bash

.PHONY: certs
certs:
# create all the certs necessary
# - certificate authority private key and cert
# - dc1 server private key and cert 
# - dc2 server private key and cert
	mkdir -p conf/certs
	pushd
	consul tls ca create
	rm -v dc1* dc2*
	consul tls cert create -server -dc=dc2 -domain=consul -additional-dnsname="*.dc1.consul" -additional-dnsname="*.dc2.consul" -additional-dnsname="*.*.dc1.consul" -additional-dnsname="*.*.dc2.consul" -additional-dnsname="dc2s1.server.dc2.consul"
	consul tls cert create -server -dc=dc1 -domain=consul -additional-dnsname="*.dc1.consul" -additional-dnsname="*.dc2.consul" -additional-dnsname="*.*.dc1.consul" -additional-dnsname="*.*.dc2.consul" -additional-dnsname="dc1s1.server.dc1.consul"
	popd

.PHONY: test
test: 
# test boot and startup of scenario is good
	docker-compose exec dc1s1 consul members -wan
# expect:
# Node       Address         Status  Type    Build      Protocol  DC   Partition  Segment
# dc1s1.dc1  10.1.10.1:8302  alive   server  1.15.0dev  2         dc1  default    <all>
# dc2s1.dc2  10.2.10.1:8302  alive   server  1.15.0dev  2         dc2  default    <all>	

	docker-compose exec dc2s1 consul members -wan
# expect: 
# Node       Address         Status  Type    Build      Protocol  DC   Partition  Segment
# dc1s1.dc1  10.1.10.1:8302  alive   server  1.15.0dev  2         dc1  default    <all>
# dc2s1.dc2  10.2.10.1:8302  alive   server  1.15.0dev  2         dc2  default    <all>	
	curl -s "http://localhost:8500/v1/catalog/services?dc=dc2" | jq .
	curl -s "http://localhost:9500/v1/catalog/services?dc=dc1" | jq .

.PHONY: follow-test
follow-test:
	while true; do make test; sleep 5; done

.PHONY: build
build:
	sh -c "cd .. && ./build-image.sh oss"

.PHONY: clean
clean:
	rm -rfv conf/data/*