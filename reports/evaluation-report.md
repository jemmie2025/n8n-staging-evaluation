# n8n Isolated Staging Evaluation Report

**Task:** #5290
**Evaluator:** Jemimah Godswill
**Date:** 27 August 2026
**Baseline:** n8n `2.36.7`

## Executive Summary

A clean n8n `2.36.7` instance was deployed in an isolated Docker Compose environment and tested successfully. Core workflows, webhooks, credential storage, service health and persistence passed without affecting production.

A read-only assessment of the MatrixForgeLabs development licence-bypass patch confirmed that it targets n8n `1.119.0`, not `2.36.7`. The patch was therefore not applied to the validated baseline, and Enterprise-feature activation remains unverified.

## Environment

| Component | Configuration |
|---|---|
| Host | Windows with WSL2 Ubuntu |
| Runtime | Docker Desktop |
| Deployment | Docker Compose |
| n8n | 2.36.7 |
| Database | PostgreSQL 16 Alpine |
| Network binding | `127.0.0.1:5678` |
| Persistence | Named Docker volumes |
| Data | Dummy test data |
| Production impact | None |

## Test Results

| Test | Result |
|---|---|
| Container deployment and health | Passed |
| HTTP Request workflow | Passed |
| JavaScript transformation | Passed |
| Webhook processing | Passed |
| Credential storage validation | Passed |
| Service restart persistence | Passed |
| Container recreation persistence | Passed |
| Patch documentation review | Completed |
| Patch integrity verification | Completed |
| Patch execution | Not performed |
| Enterprise-feature validation | Not verified |
| Clean-versus-patched comparison | Not completed |

## Baseline Findings

- n8n and PostgreSQL started successfully.
- The n8n health endpoint returned a healthy response.
- HTTP Request, JavaScript and webhook workflows executed successfully.
- The dummy credential value was not detected as plaintext in PostgreSQL.
- Workflows and credentials survived restart and container recreation.
- The environment remained isolated from production.

## Patch Assessment

| Item | Finding |
|---|---|
| Repository | `MatrixForgeLabs/n8n-dev-license-bypass` |
| Reviewed commit | `4e69096875a618d894a11b995c5658214f400e68` |
| Patch SHA-256 | `d2f4fd8cb4bcfaeed6dc7fb1e5e65885b96ce549993d48dcfe7566ecf634d6b` |
| Documented target | n8n `1.119.0` |
| Current baseline | n8n `2.36.7` |
| Compatibility | Not established |
| Review method | Read-only static analysis |

The patch modifies backend licence management, frontend feature checks, TypeScript declarations, logging, linting and workspace dependencies.

Key risks include:

- Automatic activation through development-mode fallbacks.
- Replacement of normal entitlement validation.
- Unlimited quota overrides.
- Fake management-token data.
- Frontend features appearing enabled without working backend services.
- Type-safety suppression through broad casts.
- Dependency drift and recurring upgrade maintenance.
- Unsupported behaviour across major n8n versions.

Detailed findings: [`../patch-review/static-analysis.md`](../patch-review/static-analysis.md)

## Evidence

- [Patch version incompatibility](../evidence/patch-review/09-patch-version-incompatibility.png)
- [Modified source files](../evidence/patch-review/10-patch-modified-files.png)
- [Security-risk flags](../evidence/patch-review/11-patch-security-risk-flags.png)
- [Patch integrity and clean review](../evidence/patch-review/12-patch-integrity-and-clean-review.png)

## Conclusion

The clean n8n `2.36.7` environment passed all completed baseline, regression and persistence tests.

The supplied patch targets n8n `1.119.0` and presents material compatibility, security and maintenance risks. It was not applied to the validated environment; therefore, Enterprise-feature activation, patched stability and the final before-and-after comparison remain outstanding.