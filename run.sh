#!/bin/bash

# Kill all child processes on exit
trap 'echo "Stopping services..."; kill 0' SIGINT SIGTERM EXIT

echo "Starting SeaTunnel Backend..."
cd "$(dirname "$0")/etl-orchestration-service"
./mvnw spring-boot:run &
BACKEND_PID=$!

echo "Starting ETL Orchestration Studio..."
cd "../etl-orchestration-ui"
# Install dependencies in case they are missing
npm install
npm run dev &
FRONTEND_PID=$!

echo "Services started. Press Ctrl+C to stop."
wait $BACKEND_PID $FRONTEND_PID
