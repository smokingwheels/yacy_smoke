#!/bin/bash

YACY_LOG="/home/nextcloud/Downloads/yacy_smoke/DATA/LOG/yacy00.log"
BLACKLIST="/home/nextcloud/Downloads/DATA/SETTINGS/blacklists/url.default.black"

# threshold in milliseconds
CRAWL_DELAY_THRESHOLD=10

grep "forcing crawl-delay" "$YACY_LOG" | \
while read -r line; do
    delay=$(echo "$line" | grep -oE '[0-9]+(?= milliseconds)')
    host=$(echo "$line" | awk '{print $NF}')

    if [ "$delay" -ge "$CRAWL_DELAY_THRESHOLD" ]; then
        rule="$host/*"
        if ! grep -q "^$rule$" "$BLACKLIST"; then
            echo "# auto-blacklisted due to crawl-delay ${delay}ms" >> "$BLACKLIST"
            echo "$rule" >> "$BLACKLIST"
            echo "[auto-blacklist] added $rule"
        fi
    fi
done
