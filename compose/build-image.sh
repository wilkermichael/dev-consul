#!/bin/bash

# Check if the first argument is "help"
if [ "$1" == "help" ] || [ -z "$1" ]; then
  # Print usage instructions
  echo "Usage: ./script.sh [oss|enterprise]"
  echo "Specify either 'oss' or 'enterprise' as the input argument"
  echo "Example: ./script.sh oss"
  echo "Example: ./script.sh enterprise"
  # Exit the script
  exit 0
fi

# Check if the input argument is "oss" or "enterprise"
if [ "$1" = "oss" ]; then
  # Change to the oss/image directory
  cd oss/image || exit

  # Run the build.sh script in the oss/image directory
  ./build.sh
elif [ "$1" = "enterprise" ]; then
  # Change to the enterprise/image directory
  cd enterprise/image || exit

  # Run the build.sh script in the enterprise/image directory
  ./build.sh
else
  # Print an error message if the input argument is not "oss" or "enterprise"
  echo "Error: Invalid input argument. Please specify either 'oss' or 'enterprise'"
fi