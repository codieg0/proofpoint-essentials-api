#!/bin/bash

# Check for jq and curl dependency
for cmd in jq curl; do
    if ! command -v $cmd &> /dev/null; then
        echo "❌ Error: '$cmd' is not installed. Please install it using your package manager:"
        if [ "$cmd" = "jq" ]; then
            echo "   Debian/Ubuntu: sudo apt install -y jq"
        elif [ "$cmd" = "curl" ]; then
            echo "   Debian/Ubuntu: sudo apt install -y curl"
        fi
        exit 1
    fi
done

read -p "Domain: " domain
read -p "Stack: " stack
read -p "Username: " user
read -s -p "Password: " pass
echo

# Output CSV header
echo "Email,Safelist,Blocklist" > senderlist.csv

# Loop through users
curl -s -X GET -H "X-User: $user" -H "X-Password: $pass" \
"https://$stack.proofpointessentials.com/api/v1/orgs/$domain/users" \
| jq -r '.users[] | select(.type == "end_user" or .type == "silent_user" or .type == "organization_admin" or .type == "channel_admin") | .primary_email' \
| while read email; do
  user_data=$(curl -s -X GET -H "X-User: $user" -H "X-Password: $pass" \
  "https://$stack.proofpointessentials.com/api/v1/orgs/$domain/users/$email")
  
  safelist=$(echo "$user_data" | jq -r '.white_list_senders | select(.) | join("; ")')
  blocklist=$(echo "$user_data" | jq -r '.black_list_senders | select(.) | join("; ")')

  # Handle empty values
  safelist=${safelist:-None}
  blocklist=${blocklist:-None}

  # Append to CSV
  echo "\"$email\",\"$safelist\",\"$blocklist\"" >> senderlist.csv
done

echo "✅ Output saved to senderlist.csv"