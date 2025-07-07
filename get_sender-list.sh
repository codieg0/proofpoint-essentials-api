#!/bin/bash

echo
read -p "Enter domain: " domain
read -p "Enter stack: " stack
read -p "Enter affected user email: " a_address
read -p "Enter API username: " user
read -sp "Enter API password: " password
echo

echo -e "\nGetting sender lists for $a_address\n"

curl -s -H "X-User: $user" -H "X-Password: $password" \
"https://$stack.proofpointessentials.com/api/v1/orgs/$domain/users/$a_address" | jq -r '
  "\nSafe Senders:\n" +
  (if .white_list_senders | length == 0 then "  (none)" else (.white_list_senders[] | "  - " + .) end) +
  "\n\nBlocked Senders:\n" +
  (if .black_list_senders | length == 0 then "  (none)" else (.black_list_senders[] | "  - " + .) end)
'