# n8n Staging Evaluation Report

## Assessment Details

| Field | Details |
|---|---|
| Task | #5290 |
| Assessor | Jemimah Godswill |
| Date | 26 August 2026 |
| Environment | Isolated WSL2 staging sandbox |
| Overall status | Baseline complete; patch testing blocked |
| Production impact | None |

## Executive Summary

A clean n8n staging environment was successfully deployed using Docker Compose, n8n 2.35.1 and PostgreSQL 16 Alpine.

Core workflow execution, HTTP requests, webhook processing, JavaScript transformation, dummy credential storage, service restart and container recreation were tested successfully. Workflows and credentials remained available after both restart and container recreation.

The instance reports Community Edition status. Its API confirms that SAML, LDAP and OIDC are disabled and that no licence is installed.

The third-party licence-bypass patch was not applied because written legal/security authorization or an official n8n test licence has not been provided. Enterprise-feature and post-patch regression testing therefore remain blocked.

## Environment

| Component | Configuration |
|---|---|
| Host | Windows with WSL2 Ubuntu |
| Runtime | Docker Desktop |
| Deployment | Docker Compose |
| n8n | 2.35.1 |
| Database | PostgreSQL 16 Alpine |
| Network | Isolated Docker network |
| Access | `127.0.0.1:5678` only |
| Persistence | Named Docker volumes |
| Test data | Dummy data only |

## Test Results

| Test | Status | Result |
|---|---|---|
| Docker Compose validation | PASS | Configuration returned exit code `0` |
| Clean deployment | PASS | n8n and PostgreSQL started successfully |
| Database health | PASS | PostgreSQL reported healthy |
| n8n health endpoint | PASS | Returned `{"status":"ok"}` |
| User interface | PASS | Dashboard loaded successfully |
| HTTP Request node | PASS | Local health request returned `status: ok` |
| Data transformation | PASS | Input `21` transformed to `42` |
| Webhook trigger | PASS | Test POST request was received |
| Webhook processing | PASS | Payload transformed and returned `PASS` |
| Credential storage | PASS | Dummy credential saved successfully |
| Plaintext check | PASS | Dummy value not found as plaintext in PostgreSQL |
| Service restart | PASS | Workflows and credentials persisted |
| Container recreation | PASS | Stored data remained available |
| Workflow export | PASS | Two workflows exported to JSON |
| Licence baseline | PASS | Community Edition; licence `null` |
| Enterprise flags | PASS | SAML, LDAP and OIDC reported `false` |
| Patch review | PARTIAL | Documentation and risks assessed |
| Patch application | BLOCKED | Written authorization required |
| Enterprise validation | BLOCKED | Official licence or approved patch required |

## Functional Validation

### HTTP Request and Transformation

The baseline workflow called the internal n8n health endpoint and transformed the result.

```json
{
  "service_status": "ok",
  "input_value": 21,
  "doubled_value": 42,
  "validation_result": "PASS"
}