#!/bin/bash

echo
echo "This will print important Azure details."
echo

read -p "Enter domain: " domain
read -p "Enter stack: " stack
read -p "Enter username: " user
read -s -p "Enter Password: " password
echo
echo

# Make the API call and extract key Azure settings
curl -s -X GET -H "X-User: $user" -H "X-Password: $password" \
  "https://$stack.proofpointessentials.com/api/v1/orgs/$domain/settings/azure" | jq -r '
  "primary_domain: \(.primary_domain)\n" +
  "application_id: \(.application_id)\n" +
  "secret_expiry: \(.secret_expiry)\n" +
  "last_successful_sync: \(.last_successful_sync)"
'
