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
read -p "Enter username: " user
read -s -p "Enter Password: " password
echo
read -p "Choose user type (end_user / silent_user / organization_admin / all): " usertype
echo

#Run API call and process results, append to csv
curl -s -X GET \
  -H "X-User: $user" \
  -H "X-Password: $password" \
  "https://$stack.proofpointessentials.com/api/v1/orgs/$domain/users" | jq -r --arg t "$usertype" '
    if .users == null then
      "No users found or invalid credentials."
    elif $t == "all" then
      (["email","type","status"],
       (.users[] | select(.is_active==true) | [.primary_email, .type, (if .is_active then "active" else "inactive" end)]))
      | @csv
    else
      (["email","type","status"],
       (.users[] | select(.type==$t and .is_active==true) | [.primary_email, .type, "active"]))
      | @csv
    end
' > userList.csv

echo "✅ Output saved to userList.csv"