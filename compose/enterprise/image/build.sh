set -e

# Update this directory if your path to the consul source code changes
consuldir=~/dev/consul-enterprise

make -C ~/dev/consul-enterprise linux

# Run `make linux` first.
cp $consuldir/pkg/bin/linux_amd64/consul .

CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o forwardsrv
docker build . -t dev-consul-enterprise
