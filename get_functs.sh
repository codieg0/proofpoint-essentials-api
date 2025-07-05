#!/bin/bash

echo
echo "This will list active functional_account users."
echo

read -p "Enter domain: " domain
read -p "Enter stack: " stack
read -p "Enter username: " user
read -s -p "Enter Password: " password
echo
echo

# Call the API and parse with jq
curl -s -X GET \
  -H "X-User: $user" \
  -H "X-Password: $password" \
  "https://$stack.proofpointessentials.com/api/v1/orgs/$domain/users" | jq -r '
  if .users == null then
    "No users found or invalid credentials."
  else
    ( [ .users[] | select(.type=="functional_account" and .is_active==true) ] as $fa
    | "There are \($fa | length) active functional account users.\n"
      + ($fa | map(.primary_email) | join("\n"))
    )
  end
'
