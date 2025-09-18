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
read -p "Domain: " dm
read -p "Stack: " stack
read -p "Username: " us
read -s -p "Password: " pw

# GET Requests for each lists
allow=$(curl -s -X GET -H "X-User: $us" -H "X-Password: $pw" \
  "https://$stack.proofpointessentials.com/api/v1/orgs/$dm/sender-lists" | jq -r '.allow_list[]')

block=$(curl -s -X GET -H "X-User: $us" -H "X-Password: $pw" \
  "https://$stack.proofpointessentials.com/api/v1/orgs/$dm/sender-lists" | jq -r '.block_list[]')

# Write combined CSV with headers
paste -d, <(echo "$allow") <(echo "$block") | \
  sed '1iAllow List,Block List' > safe_block_list.csv

echo "✅ Output saved to safe_block_list.csv"