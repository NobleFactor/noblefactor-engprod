---
title: "Engineering evidence archive decisions"
status: draft
created: 2026-11-20
updated: 2026-11-21
owner: "NobleFactor/engprod"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/623
---

# Engineering evidence archive decisions

[System design](engineering-evidence-archive.md) · [Roadmap](../roadmaps/engineering-evidence-archive.md)

These records explain the recommended architecture and actual alternatives considered. E1–E7 are proposals for Owner review. No engine, deployment, trust boundary, performance target or recovery objective is accepted by recording it here. [Workstation W8](agentic-developer-workstation.decisions.md#w8) separately records the Owner-approved removal of the earlier storage-uniformity constraint; it approves no replacement engine.

<a id="e1"></a>

## 1. Use an embedded transactional store for host capture

Recommend SQLite for each host's protected capture payloads, coverage, quarantine and outbox state. The service serializes writes, keeps read work bounded and verifies its durability configuration before acknowledging capture. Local search uses screened derived records with FTS5 rather than normalizing or redacting the only original.

The local job is durable operation without a network dependency or an additional database service on every workstation. Atomic payload/outbox/coverage updates remove an application-level split-write failure. SQLite's [documented application/device role](https://www.sqlite.org/whentouse.html) supports this choice; its [FTS5 facilities](https://www.sqlite.org/fts5.html) provide local indexing, but code/path/flag retrieval quality still needs representative evaluation.

PostgreSQL on every host offers transactional storage too, at the cost of a separately operated service, credentials, patching and recovery per host. An append-only file spool can preserve bytes, but indexing, crash-safe manifest updates, deduplication, quarantine and release then require additional application protocols. Neither alternative is rejected on engine uniformity grounds. Compare total maintenance and fault behavior under the agreed workload before acceptance.

The costs are serialized local writes, reader/checkpoint management, a second database implementation in the overall system, and qualification of the embedded library and filesystem. Read back FULL synchronization and platform-specific settings under the [pragma contract](https://www.sqlite.org/pragma.html#pragma_synchronous), and include the [WAL-reset fix](https://www.sqlite.org/wal.html#walreset). No comparative benchmark or power-failure qualification is claimed yet.

Payloads, forwarding operations and holds have explicit identities and restrictive deletion relationships in the design's [conceptual model](engineering-evidence-archive.md#data-model). Ordinary release cannot clear a pending/quarantined obligation to evade that constraint. The initial local retrieval cache contains screened local captures; caching arbitrary shared-query results would add holder tracking and deletion propagation responsibilities and is deferred.

```yaml
id: E1
status: proposed
supersedes: []
proposed_by: Codex
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-21T22:12:36Z'
```

<a id="e2"></a>

## 2. Put the archive contract behind an authenticated service

Recommend an archive API as the boundary for ingestion, custody, search, exact-source reads, checkpoints and administration. Agents use scoped credentials; only the service owns shared database access. The same contracts apply whether the database is nearby or remote.

The prototype's direct database sink reduces an initial service hop, but couples host delivery and authorization to database privileges/schema and does not supply the central retrieval/citation contract by itself. Shared filesystem access would also expose private state and couple clients to storage layout. The API adds a service and protocol to operate, but provides one authorization and compatibility boundary for both reads and writes. Reuse the archive service codebase rather than introducing an independent broker.

This is an architecture judgment from the [Epic's authorization and retrieval requirements](https://github.com/NobleFactor/noblefactor-engprod/issues/490) and [protection/recovery Feature (#496)](https://github.com/NobleFactor/noblefactor-engprod/issues/496), not a claim that an extra hop improves latency. Authenticate producer identity and verified bindings; client-supplied workspace or role labels are assertions, not access grants. Bounded batching amortizes protocol overhead without weakening exact-item receipts.

The CLI calls shared retrieval directly with the caller's archive grant, and local retrieval with a separate local grant. A producer identity cannot stand in for that caller. A host query proxy would need explicit delegated credentials and independent audience/scope checks; direct calls avoid that additional trust path and support people without a capture service, at the cost of direct client reachability to the shared API.

Shared and local searches return labeled streams with separate cursors, counts and read boundaries. A coordinated global rank/snapshot would require another consistency protocol; it is deferred in favor of explicit coverage and bounded views. The [retrieval contract](engineering-evidence-archive.md#retrieval-views) specifies duplicate, conflict, quarantine, indexing and policy-change behavior rather than implying that independent counts can simply be added.

```yaml
id: E2
status: proposed
supersedes: []
proposed_by: Codex
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-21T22:12:36Z'
```

<a id="e3"></a>

## 3. Keep shared originals and provenance in one PostgreSQL recovery boundary

Recommend PostgreSQL for original chunks/manifests, catalog/provenance, screened search records, checkpoints and reviewed-record links. Bounded chunks and streamed reconstruction keep large original input out of single unbounded requests. A central service owns all database writes and exposes current coverage separately from index readiness.

Keeping originals and catalog in one database avoids a cross-store commit and coordinated-restore protocol in the first deployment. PostgreSQL custody commits require durable WAL settings under the [documented commit contract](https://www.postgresql.org/docs/19/runtime-config-wal.html). This is a consistency and operations argument, not evidence that PostgreSQL is faster than SQLite for the Owner's workload.

A central SQLite service is viable for a measured small workload and would reduce database-server operation. Its competing design must meet the same concurrent retrieval, authorization, backup-coverage, restore and maintenance objectives. A separate content-addressed file/object store could reduce database growth for large artifacts, but introduces orphan reconciliation, authorization and backup alignment across stores. It is a growth alternative after artifact-volume evidence establishes the benefit; it is not prohibited.

The recommendation accepts PostgreSQL patching, backup/WAL capacity, vacuum/index maintenance and migration responsibility. Workload, artifact sizes, operator effort and restore measurements remain open. The [catalog Feature (#492)](https://github.com/NobleFactor/noblefactor-engprod/issues/492) retains provenance requirements; the Owner's later broad evaluation request means its historical datastore preference is not a blanket approval of the recommendation.

The proposed [Feature refinement and data model](engineering-evidence-archive.md#requirements-and-feature-coverage) put shared ingestion, provenance, conflict state and custody receipt issuance under #492, with query and policy behavior supplied by their respective capabilities. Deletion intent checks serialize with ingestion over the same affected identities/source selectors; independent-journal persistence precedes completion of removal. This prevents a late replay from recreating a known deleted original without adding a distributed transaction coordinator.

```yaml
id: E3
status: proposed
supersedes: []
proposed_by: Codex
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-21T22:12:36Z'
```

<a id="e4"></a>

## 4. Require distinct custody facts before local release

Recommend separate local-durability, archive-commit and backup-coverage receipts, with index readiness reported independently. Ordinary local eviction requires archive and backup coverage, retention eligibility and absence of quarantine or reconciliation holds. Explicit approved deletion is a different operation.

Deleting the forwarding row after central acknowledgment alone would conflate delivery with independent recoverability. Treating a quarantined item as no longer pending would allow retention logic to lose an undelivered original. Keeping every local copy forever avoids eviction but cannot support bounded disconnected storage. Exact receipts and explicit holds make the tradeoff observable and enforceable.

Backup coverage binds exact capture digests to a retained recovery chain and database/timeline lineage. A post-commit flush barrier is a conservative upper bound, not an invented exact transaction LSN. A base backup without the necessary WAL is insufficient for the recovery boundary described in [PostgreSQL's PITR documentation](https://www.postgresql.org/docs/19/continuous-archiving.html). Repository/key loss, expired coverage or an archive restore require receipt reconciliation.

The cost is additional custody metadata and delayed local eviction while backups lag. A disconnected host with only one durable copy remains exposed to loss of that host; no receipt language can remove that physical limitation. The Owner must establish required recovery objectives and independent failure domains before accepting the release policy.

Per-item dispositions also govern conflicts and deletion. A durable central conflict record causes the host to retain bytes and its forwarding obligation under a quarantine hold, stop automatic retries, and preserve the first citation's identity with a conflict marker. A verified deletion notice instead cancels the operation through the approved deletion path. Treating either response as ordinary successful delivery would lose the distinction. Reconnect reconciliation and retained tombstones prevent known deleted source ranges from being reintroduced by an offline outbox; [deletion status](engineering-evidence-archive.md#deletion-and-recovery) reports outstanding host purges and backup expiry separately.

```yaml
id: E4
status: proposed
supersedes: []
proposed_by: Codex
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-21T22:12:36Z'
```

<a id="e5"></a>

## 5. Use trusted processing endpoints with explicit encryption boundaries

Recommend trusted host-capture and archive services that may process plaintext, authenticated encrypted transport, encrypted persistent volumes and client-side encrypted backups. Default retrieval uses screened representations; raw originals and exports require separate privileges. This model supports server-side full-text search while protecting network traffic and stored media.

Client-only encryption that prevents the archive operator from reading originals is a different trust model. It would require local retrieval or a separately designed encrypted-search/key-sharing mechanism; ordinary server-side indexing cannot be presented as satisfying that requirement. Plaintext storage protected only by a private network also fails the recommended stored-media and backup boundary. The Owner's expectation of security does not establish approval of either trust model.

The recommendation leaves trusted-host/administrator compromise, unlocked service memory and approved raw-original access within the trusted endpoint boundary. Revocation freshness during offline operation and deletion from retained backups need explicit policies. [Feature #496](https://github.com/NobleFactor/noblefactor-engprod/issues/496) supplies the access, secret-handling, prompt-injection and deletion requirements. Owner choice Q1 in the design remains blocking for security acceptance.

```yaml
id: E5
status: proposed
supersedes: []
proposed_by: Codex
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-21T04:15:29Z'
```

<a id="e6"></a>

## 6. Use qualified encrypted backup tooling and prove restoration

Recommend pgBackRest for the proposed PostgreSQL archive, using base backups, WAL coverage and a separate encrypted repository. Restore verification includes original hashes, citations, permissions, checkpoints and the independent deletion/revocation journal. Keys have an independently recoverable custodian and must not exist only on the host being protected.

The [pgBackRest guide](https://pgbackrest.org/user-guide.html) documents client-side repository encryption, backup retention and restore operations. Pin a qualified build with the upstream cryptographic and encrypted-metadata fixes: 2.60.1 is the research baseline from the [release notes](https://pgbackrest.org/release.html). This is not permission to upgrade an installed service or a statement that the current machines have been qualified.

Periodic logical dumps can support export or simpler recovery objectives, but do not provide the same continuous WAL recovery boundary. Database replication is an availability option and can propagate unwanted changes; it does not replace retained backup history. A custom backup implementation adds correctness work already handled by existing tooling. A central SQLite alternative would need a consistent encrypted snapshot/replication recovery design; the [SQLite Online Backup API](https://www.sqlite.org/backup.html) provides consistent snapshots, not the complete custody, encryption or off-machine retention policy.

The remaining costs are backup storage and bandwidth, WAL monitoring, restore drills and key lifecycle management. Immutable retained backups can contain subsequently deleted bytes until expiry. If policy requires immediate removal from every retained copy, this recommendation needs a different erasure design; do not hide that conflict behind a logical tombstone.

The upstream release notes and referenced database documentation were fetched live on 2026-11-21. This verifies the stated research baseline, not an installed version, supported-host deployment or successful restore. A restored central archive or local store remains closed until the current deletion/revocation journal has been reconciled.

```yaml
id: E6
status: proposed
supersedes: []
proposed_by: Codex
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-21T22:12:36Z'
```

<a id="e7"></a>

## 7. Keep evidence capture and accepted engineering authority distinct

Recommend explicit records for captured assertions, captured observations, proposed conclusions and reviewed decisions, with source/revision, supporting and conflicting citations, review identity/status and supersession. People and agents use the same bounded search/source/context interface and may consult evidence during ordinary work as well as before compaction.

A summary-only memory store would lose original qualifications and rejected alternatives. Treating every captured claim as accepted knowledge would silently promote historical instructions and unsupported assertions into current authority. Retaining originals without a usable retrieval and review contract would also miss the Owner's stated purpose. These alternatives are excluded by [Epic #490](https://github.com/NobleFactor/noblefactor-engprod/issues/490) and [reviewed traceability Feature (#495)](https://github.com/NobleFactor/noblefactor-engprod/issues/495).

The cost is attributable review state and explicit uncertainty rather than automatic acceptance. A content hash is evidence of byte identity, not truth. Public documentation references private evidence only through cleared, non-secret descriptions and identifiers, with separate authorized resolution; it never embeds credentials or automatically publishes a raw transcript. The archive supplies traceability without becoming a new policy authority or general knowledge ontology.

Checkpoint streams use verified schedule/environment/role-instance identities and immutable parent-linked revisions, with guarded head updates rather than host-clock last-writer-wins ordering. Local durability, central readiness and backup coverage remain distinct. A checkpoint cannot become centrally ready before its cited originals are in central custody; a deleted or quarantined dependency stays an explicit gap. These dependencies add delivery coordination, but prevent a host switch from treating dangling citations as available evidence. Readiness never supplies acceptance of the checkpoint's conclusions.

```yaml
id: E7
status: proposed
supersedes: []
proposed_by: Codex
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-21T22:12:36Z'
```
