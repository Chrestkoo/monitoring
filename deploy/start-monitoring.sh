#!/usr/bin/env bash

set -e

SERVICE_NAME="monitoring-stack"
LOG_FILE="/var/log/custom/monitoring-stack.log"

source /opt/scripts/.env
source /opt/scripts/lib/logging.sh

log_error_telegram "$SERVICE_NAME" "START RUN" "$LOG_FILE"

cd /opt/monitoring || {
    log_error_telegram "$SERVICE_NAME" "Monitoring directory missing" "$LOG_FILE"
    exit 1
}

if ! /usr/bin/podman compose up -d; then
    log_error_telegram "$SERVICE_NAME" "Failed to start monitoring stack" "$LOG_FILE"
    exit 1
fi

log_error_telegram "$SERVICE_NAME" "Run successfully" "$LOG_FILE"

exit 0
