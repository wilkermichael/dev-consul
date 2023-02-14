set -e

# Update this directory if your path to the consul source code changes
consuldir=~/git/hashicorp/consul

make -C ${consuldir} linux
#make -C ${consuldir} dev

# Run `make linux` first.
cp $consuldir/pkg/bin/linux_arm64/consul .
#cp $consuldir/bin/consul .

#CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o forwardsrv
CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o forwardsrv
docker build . -t dev-consul
