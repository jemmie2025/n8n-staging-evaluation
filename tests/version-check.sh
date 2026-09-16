#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

compose_file="${COMPOSE_FILE:-compose.yaml}"
expected_version="${EXPECTED_N8N_VERSION:-2.36.7}"

actual_version="$(
  docker compose -f "$compose_file" exec -T n8n n8n --version |
    tr -d '\r' |
    tail -n 1
)"

if [[ "$actual_version" != "$expected_version" ]]; then
  echo "FAIL: expected n8n $expected_version but found $actual_version"
  exit 1
fi

echo "PASS: n8n version is $actual_version"
