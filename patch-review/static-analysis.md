# Static Patch Risk Assessment

## Review Status

The supplied documentation was reviewed without applying or executing the patch. Execution remains blocked pending written legal/security authorization or an official n8n test licence.

## Documented Changes

The patch reportedly:

- Replaces backend licence-manager behaviour.
- Forces frontend enterprise feature flags.
- Uses environment variables to enable the bypass.
- Requires a custom n8n source build.
- May conflict with later n8n releases.

## Risk Summary

| Risk | Severity | Impact |
|---|---|---|
| Licensing and compliance | Critical | May bypass paid licence controls |
| Non-staging activation | Critical | Bypass variables could reach unintended environments |
| Supply-chain exposure | High | Third-party scripts modify trusted application code |
| Feature inconsistency | High | UI flags may not represent functional backend capability |
| Credential security | High | Modified enterprise paths require dedicated validation |
| Upgrade compatibility | High | Changes may conflict with upstream releases |
| Maintenance overhead | High | Custom builds require repeated review and regression testing |
| Vendor support | High | Modified builds may fall outside supported configurations |

## Dependencies

The supplied documentation identifies:

- Node.js 20–24
- pnpm 10
- Git
- At least 8 GB RAM
- Increased Node.js heap allocation for some builds

## Assessment

Feature visibility alone would not establish operational viability. Each approved modified build would require security review, dependency scanning and complete workflow, credential, webhook and persistence regression testing.

## Recommendation

Use an official n8n Enterprise trial or development licence. Do not execute the third-party patch until written authorization and compliance approval are formally recorded.