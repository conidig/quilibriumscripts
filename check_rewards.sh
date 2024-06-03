#!/bin/bash

# Navigate to the directory and run the command, capturing the output
output=$(cd ~/ceremonyclient/node && ./node-1.4.18-linux-amd64 -peer-id)

# Extract the Peer ID from the output
peer_id=$(echo "$output" | grep -oP 'Peer ID: \K.*')

# URLs containing the JSON data
urls=(
    "https://quilibrium.com/rewards/pre-1.4.18.json"
    "https://quilibrium.com/rewards/post-1.4.18.json"
)

# Loop through each URL and search for the peer ID in the JSON
for url in "${urls[@]}"; do
    # Use curl to fetch the JSON and jq to parse it, looking for the peer ID and extracting the reward
    reward=$(curl -s "$url" | jq -r --arg PID "$peer_id" '.[] | select(.peerId == $PID) | .reward')

    # Check if a reward was found and break the loop if it was
    if [[ -n "$reward" ]]; then
        echo "Reward for Peer ID $peer_id: $reward"
        break
    fi
done

# If no reward was found after looping through all URLs
if [[ -z "$reward" ]]; then
    echo "No reward found for Peer ID $peer_id"
fi
