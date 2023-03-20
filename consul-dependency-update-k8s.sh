#!/bin/bash

# Get version number as argument
version=$1

# Find all subdirectories containing a go.mod file
subdirs=$(find . -name "go.mod" -exec dirname {} \;)

# Loop through subdirectories
for dir in $subdirs; do
    echo "Processing $dir..."

    # Run go get commands with the specified version
    (cd "$dir" && go get github.com/hashicorp/consul/envoyextensions@$version)
    (cd "$dir" && go get github.com/hashicorp/consul/api@$version)
    (cd "$dir" && go get github.com/hashicorp/consul/troubleshoot@$version)

    # Run go mod tidy
    (cd "$dir" && go mod tidy)
done