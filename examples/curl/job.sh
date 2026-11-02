#!/usr/bin/env bash
# SEEK Job API – cURL example
# Usage: PILOTERR_API_KEY=your-key ./job.sh
set -euo pipefail

curl -sS --fail-with-body -G "https://api.piloterr.com/v2/seek/job" \
  -H "x-api-key: ${PILOTERR_API_KEY}" \
  --data-urlencode query=https://www.seek.com.au/job/95568355
