spatel's steps to reproduce

1. edit `compose/oss/image/build.sh`
   - update `consuldir` to point to your local git checkout of the consul git repo
   - replace `linux_arm64` with `linux_amd64` if you're on not on an M1 mac
2. cd `compose` and run `./build-image.sh oss`
3. cd `compose/oss`
4. run `make start` to start everything via docker-compose
5. run `make stop` to stop everything via docker-compsoe
6. may be a bunch of useful make targets in the Makefile
