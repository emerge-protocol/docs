#!/bin/sh
set -e

# Mintlify wraps Next.js which respects the HOSTNAME env var for binding.
# Try binding to 0.0.0.0 directly first; fall back to socat proxy if needed.

export HOSTNAME=0.0.0.0
export PORT=3000

echo "Starting mintlify dev server..."
mintlify dev --port 3000 &
MINT_PID=$!

# Wait for the server to become ready (up to 120s)
for i in $(seq 1 60); do
  if curl -sf http://localhost:3000/ > /dev/null 2>&1; then
    break
  fi
  sleep 2
done

# Check if it's reachable on 0.0.0.0 (not just localhost)
if curl -sf http://0.0.0.0:3000/ > /dev/null 2>&1; then
  echo "Mintlify dev server listening on 0.0.0.0:3000"
  wait $MINT_PID
else
  echo "Mintlify bound to localhost only — starting socat proxy"
  kill $MINT_PID 2>/dev/null || true
  sleep 2

  # Restart without HOSTNAME override on a different port
  unset HOSTNAME
  mintlify dev --port 3001 &
  MINT_PID=$!

  # Wait for mint to be ready on localhost:3001
  for i in $(seq 1 60); do
    if curl -sf http://127.0.0.1:3001/ > /dev/null 2>&1; then
      break
    fi
    sleep 2
  done

  # Proxy external traffic to the localhost-bound server
  echo "Proxying 0.0.0.0:3000 -> 127.0.0.1:3001"
  socat TCP-LISTEN:3000,fork,reuseaddr TCP:127.0.0.1:3001 &

  wait $MINT_PID
fi
