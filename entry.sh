#!/bin/bash

# start cron
#/usr/sbin/crond -f -l 8

OUTPUT_FILE="/home/jota/sitelist"
> "$OUTPUT_FILE"

IFS=',' read -ra domains <<< "$SC_DOMAINS"
for domain in "${domains[@]}"; do
    echo "$domain" >> "$OUTPUT_FILE"
done

/home/jota/ssl-check-wrapper.sh
