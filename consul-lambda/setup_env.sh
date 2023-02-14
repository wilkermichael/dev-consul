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
CONSUL_LICENSE=$(cat ../license/license.txt)
export CONSUL_LICENSE

# Setup HCP
export HCP_CLIENT_ID=$(cat ../license/hcp_client_id.txt)
export HCP_CLIENT_SECRET=$(cat ../license/hcp_client_secret.txt)