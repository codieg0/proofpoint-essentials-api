#!/bin/bash

# Check for jq and curl dependency
for cmd in jq curl; do
    if ! command -v $cmd &> /dev/null; then
        echo "❌ Error: '$cmd' is not installed. Please install it using your package manager:"
        if [ "$cmd" = "jq" ]; then
            echo "Ubuntu: sudo apt install -y jq"
        elif [ "$cmd" = "curl" ]; then
            echo "Ubuntu: sudo apt install -y curl"
        fi
        exit 1
    fi
done

# Asking users for the important details
echo
read -p "Enter domain: " domain
read -p "Enter stack: " stack
read -p "Affected user address: " a_address
read -p "Enter username: " user
read -sp "Enter Password: " password
echo

# Get user JSON data
json=$(curl -s -H "X-User: $user" -H "X-Password: $password" \
    "https://$stack.proofpointessentials.com/api/v1/orgs/$domain/users/$a_address")

# Update the is_billable field to false
updated=$(echo "$json" | jq '.is_billable = false')

# Send the updated JSON back via PUT request
curl -s -X PUT -H "X-User: $user" -H "X-Password: $password" -H "Content-Type: application/json" \
    -d "$updated" "https://$stack.proofpointessentials.com/api/v1/orgs/$domain/users/$a_address"