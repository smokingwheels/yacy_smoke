#!/bin/bash

YACY_LOG="/home/john/yacy26dec2/DATA/LOG/yacy00.log"
BLACKLIST="/home/john/yacy26dec2/DATA/LISTS/url.default.black"

# threshold in milliseconds
CRAWL_DELAY_THRESHOLD=10

grep "forcing crawl-delay" "$YACY_LOG" | while read -r line; do

    delay=$(echo "$line" | sed -n 's/.*forcing crawl-delay of \([0-9]\+\).*/\1/p')
    host=$(echo "$line" | sed -n 's/.* for \([^: ]\+\).*/\1/p')

    # sanity checks
    [[ -z "$delay" || ! "$delay" =~ ^[0-9]+$ ]] && continue
    [[ -z "$host" ]] && continue

    # skip numeric "hosts" (safety net)
    [[ "$host" =~ ^[0-9]+$ ]] && continue

    if (( delay >= CRAWL_DELAY_THRESHOLD )); then
        rule="$host/*"
        if ! grep -Fxq "$rule" "$BLACKLIST"; then
            {
                echo "# auto-blacklisted due to crawl-delay ${delay}ms"
                echo "$rule"
            } >> "$BLACKLIST"
            echo "[auto-blacklist] $host (${delay}ms)"
        fi
    fi
done
