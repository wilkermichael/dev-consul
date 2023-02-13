set -e

consuldir=~/dev/consul

make -C ~/dev/consul linux

# Run `make linux` first.
cp $consuldir/pkg/bin/linux_amd64/consul .

CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o forwardsrv
docker build . -t test-consul
