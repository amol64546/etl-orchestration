#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$BASE_DIR/.services.pid"

if [ -f "$PID_FILE" ]; then
    echo "Stopping services..."
    while read -r pid; do
        if kill -0 "$pid" 2>/dev/null; then
            echo "Stopping process tree for PID $pid..."
            # Stop direct child processes
            pkill -P "$pid" 2>/dev/null
            # Stop the process itself
            kill "$pid" 2>/dev/null
        fi
    done < "$PID_FILE"
    
    # Clean up PID file
    rm -f "$PID_FILE"
    
    # Add a fallback to ensure java/node processes started by the scripts are killed
    # just in case pkill -P didn't catch nested children.
    # We do a targeted pkill based on the paths or specific commands.
    pkill -f "apache-seatunnel-2.3.13" 2>/dev/null
    pkill -f "etl-orchestration-service.*spring-boot" 2>/dev/null
    pkill -f "etl-orchestration-ui.*vite" 2>/dev/null
    
    echo "All services stopped."
else
    echo "No .services.pid file found. Are services running?"
    echo "Attempting to clean up any dangling processes just in case..."
    pkill -f "apache-seatunnel-2.3.13" 2>/dev/null
    pkill -f "etl-orchestration-service.*spring-boot" 2>/dev/null
    pkill -f "etl-orchestration-ui.*vite" 2>/dev/null
    echo "Cleanup complete."
fi
