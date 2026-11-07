---
title: "Repository-specific requirements retained"
status: draft
created: 2026-10-28
updated: 2026-10-28
---

# Repository-specific requirements retained

The inventory identified devlore-cli-specific instructions that must remain with that repository or be explicitly reclassified, not silently promoted to universal standards:

- Build/test/vet through Make, with the explicit immediate-gofmt exception.
- Greenfield product policy: no compatibility scaffolding, old-format/signature fallbacks or success stubs. The text search for legacy/backward/compat/deprecated is a prescribed heuristic, not semantic proof.
- Verify corresponding code removal when removing comments, and tests rejecting obsolete forms.
- Default branch develop.
- Package manifest is packages-manifest.yaml or packages-manifest.json.
- Schema identity is schema.DevloreSchema, with no aliases.
- Decryptor signature is func(string, []byte) ([]byte, error), with no fallback.
- Session-start/compaction reads and consultation of the known judgment-error issue before completion.

The exact source is retained in the source manifest. The greenfield policy applies to DevLore across devlore-cli, devlore-registry and devlore.noblefactor.com, as defined in the shared coding index. The remaining repository-specific declarations are preserved for review, not promoted to organization-wide requirements.
