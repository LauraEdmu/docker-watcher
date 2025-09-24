#!/usr/bin/env bash
set -uo pipefail

set -a
. <(tr -d '\r' < /scripts/.env)
set +a

WEBHOOK_URL="$WEBHOOK_URL"
PATTERN="$PATTERN"
LOGFILE="/watch/$LOG_FILE"


# Follow by filename (handles rotation), force line-buffering through the pipeline
tail -F "$LOGFILE" \
| stdbuf -oL -eL rg --line-buffered -i --color=never -- "$PATTERN" \
| while IFS= read -r line; do
  # Escape JSON safely (uses jq). If you don't have jq, see alt below.
  payload=$(jq -Rn --arg content "$line" '{content:$content}')
  curl -sS -X POST -H "Content-Type: application/json" \
       -d "$payload" "$WEBHOOK_URL" \
       -o /dev/null
done
