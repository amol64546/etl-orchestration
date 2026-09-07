# ETL Orchestration

An orchestration tool for managing ETL (Extract, Transform, Load) pipelines, featuring a backend service, a frontend UI, and Apache SeaTunnel for data integration.

## Architecture

* **Backend Service (`etl-orchestration-service`)**: A Java Spring Boot application (Port: 8082).
* **Frontend UI (`etl-orchestration-ui`)**: A web interface built with Vite (Port: 3000).
* **Data Integration (`apache-seatunnel-2.3.13`)**: Apache SeaTunnel engine for data synchronization (Port: 5801/8081).
* **Database**: MongoDB (Requires local instance running on port 27017).

## Prerequisites

Before running the application, ensure you have the following installed and running:
* **Java** (JDK 8/11/17 depending on Spring Boot/SeaTunnel requirements)
* **Node.js** and **npm**
* **Maven** (`mvn`)
* **MongoDB** (running on `localhost:27017`)

## Running the Application

To start all services simultaneously, use the provided `run.sh` script:

```bash
./run.sh
```

This script will:
1. Check if MongoDB is running.
2. Start Apache SeaTunnel in the background.
3. Start the ETL Orchestration Service (Spring Boot) in the background.
4. Install npm dependencies and start the ETL Orchestration UI in the background.
5. Save process IDs to `.services.pid` for clean shutdown.

## Stopping the Application

To stop all running services, use the `stop.sh` script:

```bash
./stop.sh
```

This will gracefully terminate the frontend, backend, and SeaTunnel processes.
