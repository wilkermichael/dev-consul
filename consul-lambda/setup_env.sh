#!/bin/bash

# Upgrade doormat
brew tap hashicorp/security git@github.com:hashicorp/homebrew-security.git
brew upgrade hashicorp/security/doormat-cli

# Login to doormat
doormat login -f

# Setup AWS Credentials
source <(doormat aws export --account aws_mwilkerson_test)
export AWS_REGION=us-west-2

# Setup Consul Credentials
CONSUL_LICENSE=$(cat /Users/mwilkerson/dev/michael-dev-config/consul_license.txt)
export CONSUL_LICENSE

# Setup HCP
export HCP_CLIENT_ID=ef550598-b654-43de-a435-44175f74b0ae
export HCP_CLIENT_SECRET=rTtR4iw41wqMer05dHhARpVNRI1nrmGd980TU3fI6Tx1lh4Q_aUMO8PvO1123mSt\n