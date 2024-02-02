#!/bin/bash

# Initialize counters
v1_count=0
v2_count=0
total_count=0

while true; do
    # Run the command and capture the output
    output=$(kubectl --context kind-dc1 exec deploy/static-client -c static-client -- curl -vvvsSf http://static-server.virtual.consul 2>/dev/null)

    if [[ $? -ne 0 ]]; then
        echo "An error occurred. Please check your kubectl and curl commands."
        exit 1
    fi

    if [[ $output == *"I am v1"* ]]; then
        ((v1_count++))
    elif [[ $output == *"I am v2"* ]]; then
        ((v2_count++))
    fi

    ((total_count++))

    # Calculate the percentages
    v1_percentage=$((v1_count * 100 / total_count))
    v2_percentage=$((v2_count * 100 / total_count))

    # Get the current timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Update the CI with the percentages and the timestamp
    printf "\r$timestamp - Total: $total_count, V1: $v1_count req/$v1_percentage%%, V2: $v2_count req/$v2_percentage%%"

    sleep 0.003
done

# Print a newline at the end to ensure the terminal prompt appears on a new line
echo