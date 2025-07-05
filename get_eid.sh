#!/bin/bash

echo
echo "This will print an organization EID."
echo

read -p "Enter domain: " domain
read -p "Enter stack: " stack
read -p "Enter username: " user
read -s -p "Enter Password: " password
echo
echo

# Fetch EID
eid=$(curl -s -X GET -H "X-User: $user" -H "X-Password: $password" \
  "https://$stack.proofpointessentials.com/api/v1/orgs/$domain/" \
  | jq -r '.eid')

echo "eid: $eid"
echo
echo "https://$stack.proofpointessentials.com/index01.php?mod_id=3&fa=su&e_id=$eid"
