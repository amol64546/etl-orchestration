#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$BASE_DIR/.services.pid"

# Clear existing PID file if it exists
> "$PID_FILE"

if ! (echo > /dev/tcp/localhost/27017) 2> /dev/null; then
    echo "Error: MongoDB is not running on localhost:27017. Please start it first."
    exit 1
fi
echo "MongoDB is running"

echo "Starting Apache SeaTunnel 2.3.13 in background..."
nohup "$BASE_DIR/apache-seatunnel-2.3.13/bin/seatunnel.sh" --config "$BASE_DIR/apache-seatunnel-2.3.13/config/v2.streaming.conf.template" -m local > /dev/null 2>&1 &
SEATUNNEL_PID=$!
echo $SEATUNNEL_PID >> "$PID_FILE"
echo "Apache SeaTunnel started (Port: 5801/8081)."

echo "Starting ETL Orchestration Service in background..."
cd "$BASE_DIR/etl-orchestration-service"
nohup mvn spring-boot:run > /dev/null 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID >> "$PID_FILE"
echo "ETL Orchestration Service started (Port: 8082)."

echo "Starting ETL Orchestration UI in background..."
cd "$BASE_DIR/etl-orchestration-ui"
# Install dependencies in case they are missing
npm install > /dev/null 2>&1
nohup npm run dev > /dev/null 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID >> "$PID_FILE"
echo "ETL Orchestration UI started (Port: 3000)."

echo "All services have been started in the background!"
echo "Run ./stop.sh to stop all services."
