#!/bin/bash

# Function to send a Slack notification
notify_slack() {
  WEBHOOK=$SC_SLACK_WEBHOOK
  SLACK_CHANNEL=$SC_SLACK_CHANNEL
  SLACK_BOTNAME=$SC_SLACK_BOTNAME
  
  OUTPUT="$1"
  COLOR="$2"

  SLACK_PAYLOAD="{
    \"channel\": \"${SLACK_CHANNEL}\",
    \"icon_emoji\": \":skull:\",
    \"username\": \"${SLACK_BOTNAME}\",
    \"attachments\": [{
      \"color\": \"${COLOR}\",
      \"fields\": [
        {\"title\": \"Report:\", \"value\": \"${OUTPUT}\"},
      ]
    }]
  }"

  # Send the payload to Slack using curl
  curl -X POST --data-urlencode "payload=${SLACK_PAYLOAD}" $WEBHOOK
}

# Get the output of the script and filter for Alert, Expired, or Unknown statuses
output=$(alert_days=$SC_STATUS_ALERT_DAYS ./jota-cert-checker.sh -f sitelist -o terminal | grep -E 'Alert|Expired|Unknown')
output2=$(echo $output | head -n -3)

# Check if output is not empty
if [[ ! -z $output2 ]]; then

    color="#ff0000"
    clean_output=$(echo "$output" | sed -r 's/\x1b\[[0-9;]*m//g')
    notify_slack "$clean_output" "$color"

fi
