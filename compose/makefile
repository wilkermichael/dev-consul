enterprise:
	@cd enterprise; docker-compose up -d; sleep 6; ./peer.sh

enterprise-down:
	@cd enterprise; docker-compose down

enterprise-acls:
	@cd enterprise-acls; docker-compose up -d; sleep 6; ./peer.sh

enterprise-acls-down:
	@cd enterprise-acls; docker-compose down

wan-fed:
	@cd wan-fed; docker-compose up -d

wan-fed-down:
	@cd wan-fed; docker-compose down

wan-fed-acls:
	@cd wan-fed-acls; docker-compose up

wan-fed-acls-down:
	@cd wan-fed-acls; docker-compose down

oss:
	@cd oss; docker-compose up -d; ./peer.sh

oss-down:
	@cd oss; docker-compose down

oss-image:
	./build-image.sh oss

enterprise-image:
	./build-image.sh enterprise

.PHONY: enterprise oss wan-fed wan-fed-acls enterprise-acls enterprise-image oss-image enterprise-down oss-down wan-fed-down enterprise-acls-down wan-fed-acls-down