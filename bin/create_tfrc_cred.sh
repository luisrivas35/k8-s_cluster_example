#!/usr/bin/env bash

# Path to the credentials.tfrc.json file
file_path="/home/gitpod/.terraform.d/credentials.tfrc.json"

# Ensure the directory structure exists
mkdir -p "$(dirname "$file_path")"

# Check if the TERRAFORM_CLOUD_TOKEN environment variable is set
if [ -z "$TERRAFORM_CLOUD_TOKEN" ]; then
  echo "Error: TERRAFORM_CLOUD_TOKEN environment variable is not set."
  exit 1
fi

# Create the credentials.tfrc.json file with the JSON structure
cat <<EOL > "$file_path"
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TERRAFORM_CLOUD_TOKEN"
    }
  }
}
EOL

echo "credentials.tfrc.json file has been created successfully at $file_path."
