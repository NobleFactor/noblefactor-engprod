---
title: "4. Storage and reach — Status"
---

# 4. Storage and reach — Status

**Document:** [4-storage-and-reach.md](4-storage-and-reach.md)
**Feature:** [NobleFactor/noblefactor-ops#331](https://github.com/NobleFactor/noblefactor-ops/issues/331)
**Work:** [NobleFactor/noblefactor-ops#303](https://github.com/NobleFactor/noblefactor-ops/issues/303)
**State:** Ruled 2026-10-22: Type and the parent are GitHub's; personal keeps labels synced one way; the sub-issue link
crosses repositories and owners, proven by the write test of that day. The write test's second half, an option updated
by id, passed 2026-10-26 under #377, and blocked-by links cross repositories and owners, 2026-11-01. The
plan's question 17, added 2026-11-02, asks whether an organization's records may point at a personal repository at all. Ruled 2026-11-02: organizations and individual accounts are separate, each with its own model
(§ Accounts in section 4); question 17 settled the same day, and the model read on demand from two reference
models (§ Reference models, read on demand, in section 6). Revised the same day: each participating account keeps its
model in its own `.github` repository (#431, David-Noble-at-work/personal#311), which section 6 states with #431.

## Completion

- [ ] The plan's questions 1 and 13 ruled: where Type, Severity and Priority live, and where the parent link lives.
- [ ] A write test: whether a sub-issue link and a blocked-by link cross repositories, and owners.
- [ ] The audit checks every rule GitHub does not enforce, and reports without correcting.
