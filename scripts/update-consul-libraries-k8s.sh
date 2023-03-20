#!/bin/bash

# Get version number as argument
version=$1

# Find all subdirectories containing a go.mod file
subdirs=$(find . -name "go.mod" -exec dirname {} \;)

# Loop through subdirectories
for dir in $subdirs; do
    echo "Processing $dir..."

    # Check if module contains library already
    (cd "$dir" && go list -m all 2>/dev/null | grep -q "^github.com/hashicorp/consul/envoyextensions ") && {
        # Library exists in module, upgrade it
        (cd "$dir" && go get github.com/hashicorp/consul/envoyextensions@$version)
    }

    (cd "$dir" && go list -m all 2>/dev/null | grep -q "^github.com/hashicorp/consul/api ") && {
        # Library exists in module, upgrade it
        (cd "$dir" && go get github.com/hashicorp/consul/api@$version)
    }

    (cd "$dir" && go list -m all 2>/dev/null | grep -q "^github.com/hashicorp/consul/troubleshoot ") && {
        # Library exists in module, upgrade it
        (cd "$dir" && go get github.com/hashicorp/consul/troubleshoot@$version)
    }
done