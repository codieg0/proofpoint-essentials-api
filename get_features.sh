#!/bin/bash

echo
echo "This script will print all the active features for a Proofpoint Essentials organization."
echo

read -p "Enter domain: " domain
read -p "Enter stack: " stack
read -p "Enter username: " user
read -s -p "Enter Password: " password
echo
echo

# Query features
response=$(curl -s -X GET -H "X-User: $user" -H "X-Password: $password" "https://$stack.proofpointessentials.com/api/v1/orgs/$domain/features")

# Print active features, including special formatting for instant_replay
echo "$response" | jq -r '
  [to_entries[] 
    | select(.key != "instant_replay" and .value == true) 
    | .key] 
  + [if .instant_replay == 0 then "instant_replay: Off" else "instant_replay: \(.instant_replay) days" end] 
  | .[]
'
