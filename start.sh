#!/bin/bash

# Create a directory for Docker logs that the current user can write to
LOG_DIR="$HOME/docker_logs"
mkdir -p "$LOG_DIR"

# Start Docker daemon in the background
echo "Starting Docker daemon..."
sudo dockerd > "$LOG_DIR/dockerd.log" 2>&1 &

# Wait for Docker to start
echo "Waiting for Docker daemon to start..."
timeout=30
while ! sudo docker info >/dev/null 2>&1; do
  timeout=$((timeout - 1))
  if [ $timeout -eq 0 ]; then
    echo "Docker daemon failed to start"
    cat "$LOG_DIR/dockerd.log"
    exit 1
  fi
  sleep 1
done
echo "Docker daemon started successfully"

# Start code-server with the arguments passed to this script
echo "Starting code-server..."
exec code-server --bind-addr 0.0.0.0:8080 "$@"