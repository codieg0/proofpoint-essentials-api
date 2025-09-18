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

echo
echo "This will list active functional_account users"
echo

# Asking users for the important details
read -p "Enter domain: " domain
read -p "Enter stack: " stack
read -p "Enter username: " user
read -s -p "Enter Password: " password
echo
echo

# GET Request
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