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

.PHONY: follow-dc2s1
follow-dc2s1:
	while true; do docker-compose logs --follow --tail=0 dc2s1; sleep 2; done

.PHONY: follow-mgw1
follow-mgw1:
	while true; do docker-compose logs --follow --tail=0 mgw1; sleep 2; done

.PHONY: follow-mgw2
follow-mgw2:
	while true; do docker-compose logs --follow --tail=0 mgw2; sleep 2; done

.PHONY: shell-dc1s1
shell-dc1s1:
	docker-compose exec dc1s1 /bin/bash

.PHONY: shell-dc2s1
shell-dc2s1:
	docker-compose exec dc2s1 /bin/bash	

.PHONY: shell-mgw1
shell-mgw1:
	docker-compose exec mgw1 /bin/bash

.PHONY: shell-mgw2
shell-mgw2:
	docker-compose exec mgw2 /bin/bash


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
	consul tls cert create -server -dc=dc2 -domain=consul -additional-dnsname="*.dc1.consul" -additional-dnsname="*.dc2.consul" -additional-dnsname="*.*.dc1.consul" -additional-dnsname="*.*.dc2.consul"
	consul tls cert create -server -dc=dc1 -domain=consul -additional-dnsname="*.dc1.consul" -additional-dnsname="*.dc2.consul" -additional-dnsname="*.*.dc1.consul" -additional-dnsname="*.*.dc2.consul" -additional-dnsname="dc1s1.server.dc1.consul"
	popd