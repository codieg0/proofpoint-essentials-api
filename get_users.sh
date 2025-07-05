#!/bin/bash

echo
read -p "Enter domain: " domain
read -p "Enter stack: " stack
read -p "Enter username: " user
read -s -p "Enter Password: " password
echo
echo
read -p "Choose user type (end_user / silent_user / organization_admin / all): " usertype
echo

# Make the API call and filter with jq
curl -s -X GET -H "X-User: $user" -H "X-Password: $password" \
    "https://$stack.proofpointessentials.com/api/v1/orgs/$domain/users" | jq -r --arg t "$usertype" '
  if .users == null then
    "No users found or invalid credentials."
  elif $t == "all" then
    ( [ .users[] | select(.is_active==true) ] as $all
    | "There are \($all|length) active users.\n\n"
      + "\($all|map(select(.type == \"organization_admin\"))|length) Org. Admins\n"
      + "\($all|map(select(.type == \"end_user\"))|length) End Users\n"
      + "\($all|map(select(.type == \"silent_user\"))|length) Silent Users\n\n"
      + "Org. Admins\n"
      + ($all|map(select(.type == \"organization_admin\")|.primary_email) | join("\n"))
      + "\n\n"
      + "End Users\n"
      + ($all|map(select(.type == \"end_user\")|.primary_email) | join("\n"))
      + "\n\n"
      + "Silent Users\n"
      + ($all|map(select(.type == \"silent_user\")|.primary_email) | join("\n"))
    )
  else
    ( [ .users[] | select(.type==$t and .is_active==true) ] as $filtered
    | "There are \($filtered|length) active \($t) users.\n\n"
      + ($filtered|map(.primary_email) | join("\n"))
    )
  end
'
