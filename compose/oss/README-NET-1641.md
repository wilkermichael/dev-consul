spatel's steps to reproduce

1. edit `compose/oss/image/build.sh`
   - update `consuldir` to point to your local git checkout of the consul git repo
   - replace `linux_arm64` with `linux_amd64` if you're on not on an M1 mac
2. cd `compose` and run `./build-image.sh oss`
3. cd `compose/oss`
4. run `make start` to start everything via docker-compose
5. run `while true; do make test; sleep 5; done` should eventually show both dcs aware of 
   each others services
6. kill consul server in dc2 to repro errors in dc1s1 logs: `docker-compose stop dc2s1`
7. run `make stop` to stop everything via docker-compsoe
8. may be a bunch of useful make targets in the Makefile
