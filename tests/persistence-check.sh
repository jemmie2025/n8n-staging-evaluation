#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

compose_file="${COMPOSE_FILE:-compose.yaml}"

snapshot_counts() {
  docker compose -f "$compose_file" exec -T postgres sh -lc '
    psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tAc "
      SELECT COUNT(*) FROM workflow_entity;
      SELECT COUNT(*) FROM credentials_entity;
    "
  '
}

wait_for_health() {
  for attempt in {1..30}; do
    if ./tests/health-check.sh >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done

  echo "FAIL: services did not become healthy within 60 seconds"
  return 1
}

before="$(snapshot_counts)"

docker compose -f "$compose_file" restart >/dev/null
wait_for_health
after_restart="$(snapshot_counts)"

if [[ "$before" != "$after_restart" ]]; then
  echo "FAIL: data counts changed after service restart"
  exit 1
fi

echo "PASS: data persisted after service restart"

docker compose -f "$compose_file" down >/dev/null
docker compose -f "$compose_file" up -d >/dev/null
wait_for_health
after_recreation="$(snapshot_counts)"

if [[ "$before" != "$after_recreation" ]]; then
  echo "FAIL: data counts changed after container recreation"
  exit 1
fi

echo "PASS: data persisted after container recreation"
