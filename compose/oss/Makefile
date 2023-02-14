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

.PHONY: shell-dc1s1
shell-dc1s1:
	docker-compose exec dc1s1 /bin/bash

.PHONY: shell-dc2s1
shell-dc2s1:
	docker-compose exec dc2s1 /bin/bash	