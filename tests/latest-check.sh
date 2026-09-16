#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

export COMPOSE_FILE="compose.latest.yaml"
export N8N_BASE_URL="http://localhost:5679"
export EXPECTED_N8N_VERSION="${N8N_LATEST_VERSION:-2.38.7}"

./tests/health-check.sh
./tests/version-check.sh

echo "PASS: isolated latest-version baseline checks completed"
