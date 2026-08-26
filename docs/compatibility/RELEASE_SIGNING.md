# Release Signing Strategy

## Phase 10 decision

**Optional GPG signing** for maintainers who have keys; **not required** for development tags.

| Method | Use |
|--------|-----|
| SHA-256 checksums | **Required** for any published archive |
| GPG detach-sign | Optional when a maintainer key is available |
| Sigstore/cosign | Deferred (ops overhead) |

## Rules

- Never commit private keys or passphrases  
- Never log secrets in Actions  
- Prefer environment-protected signing secrets if enabled later  

Unsigned pre-release artifacts are acceptable if checksums are published and the project remains `*-dev` / RC.
