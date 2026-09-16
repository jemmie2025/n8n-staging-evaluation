#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

compose_file="${COMPOSE_FILE:-compose.yaml}"
base_url="${N8N_BASE_URL:-http://localhost:5678}"

docker compose -f "$compose_file" config --quiet

postgres_id="$(docker compose -f "$compose_file" ps -q postgres)"

if [[ -z "$postgres_id" ]]; then
  echo "FAIL: PostgreSQL container is not running"
  exit 1
fi

postgres_health="$(
  docker inspect \
    --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' \
    "$postgres_id"
)"

if [[ "$postgres_health" != "healthy" ]]; then
  echo "FAIL: PostgreSQL status is $postgres_health"
  exit 1
fi

health_response="$(
  curl \
    --fail \
    --silent \
    --show-error \
    --retry 10 \
    --retry-delay 2 \
    --retry-connrefused \
    "$base_url/healthz"
)"

if ! jq -e '.status == "ok"' >/dev/null <<<"$health_response"; then
  echo "FAIL: n8n health response was $health_response"
  exit 1
fi

echo "PASS: PostgreSQL is healthy"
echo "PASS: n8n health endpoint returned status ok"
