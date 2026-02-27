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
READY=0
for i in $(seq 1 60); do
  if curl -sf http://localhost:3000/ > /dev/null 2>&1; then
    READY=1
    break
  fi
  sleep 2
done

# Check if it's reachable on a non-loopback interface.
# 0.0.0.0 is not a reliable connectivity probe.
CONTAINER_IP=""
for ip in $(hostname -i 2>/dev/null || true); do
  case "$ip" in
    127.*|::1)
      ;;
    *)
      CONTAINER_IP="$ip"
      break
      ;;
  esac
done

if [ -n "$CONTAINER_IP" ] && curl -sf "http://${CONTAINER_IP}:3000/" > /dev/null 2>&1; then
  echo "Mintlify dev server reachable on ${CONTAINER_IP}:3000"
  wait $MINT_PID
else
  echo "Mintlify not reachable on container interface — starting socat proxy"

  # Graceful kill with force fallback
  kill "$MINT_PID" 2>/dev/null || true
  for i in $(seq 1 5); do
    if ! kill -0 "$MINT_PID" 2>/dev/null; then
      break
    fi
    sleep 1
  done
  kill -9 "$MINT_PID" 2>/dev/null || true

  # Restart without HOSTNAME override on a different port
  unset HOSTNAME
  mintlify dev --port 3001 &
  MINT_PID=$!

  # Wait for mint to be ready on localhost:3001
  READY=0
  for i in $(seq 1 60); do
    if curl -sf http://127.0.0.1:3001/ > /dev/null 2>&1; then
      READY=1
      break
    fi
    sleep 2
  done

  if [ "$READY" -eq 0 ]; then
    echo "Mintlify dev server on port 3001 did not become ready in 120s — exiting"
    kill "$MINT_PID" 2>/dev/null || true
    exit 1
  fi

  # Proxy external traffic to the localhost-bound server
  echo "Proxying 0.0.0.0:3000 -> 127.0.0.1:3001"
  socat TCP-LISTEN:3000,fork,reuseaddr TCP:127.0.0.1:3001 &

  wait $MINT_PID
fi
