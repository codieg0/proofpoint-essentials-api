#!/bin/bash

echo
echo "This will print all the users being exempted from Azure."
echo

read -p "Enter domain: " domain
read -p "Enter stack: " stack
read -p "Enter username: " user
read -s -p "Enter Password: " password
echo
echo

response=$(curl -s -X GET -H "X-User: $user" -H "X-Password: $password" \
    "https://$stack.proofpointessentials.com/api/v1/orgs/$domain/settings/azure/exemptions")

echo "$response" | jq -r '.[].email'

