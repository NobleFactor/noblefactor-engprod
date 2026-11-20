---
title: "SBX session deployment decisions"
status: draft
updated: 2026-11-19
---

# SBX session deployment decisions

[Proposal](3-agent-sandbox.md) · [Source and delivery references](3-agent-sandbox.status.md)

## 1. Place the native session and client shells in one guest

**Status:** proposed topology.

One SBX sandbox supplies the shared workspace, tools and native Claude session. Each client creates a separate guest shell and attaches a viewer to that session. Client tmux supplies the layout; a second guest tmux layer is unnecessary for this topology.

**Alternatives and consequences:** one guest per client would separate files and processes that this workflow intends to share. A separate shell provides process independence but no filesystem or security isolation from other clients.

## 2. Attach through the native guest client

**Status:** proposed; qualification required.

Prefer `claude attach <id>` inside the guest, using the recorded native identity. The alternative is a private session-file or socket integration with an explicit transport.

**Reason:** native attachment owns endpoint discovery. A guest Unix path is not a remote address, and private native file layouts can change.

**Consequence:** the installed Claude and SBX versions must support the intended multi-client and PTY behavior. This proposal makes no promise about an unqualified private socket API.

## 3. Preserve the conversation independently of client transport

**Status:** required outcome; launch mechanics require qualification.

The native background session must survive the launch command and individual viewer connections. Merely placing an SBX execution command in the host shell's background does not prove that lifetime.

The terminal-detach choice is open: persistent client tmux would retain shells, while the standalone launcher's `destroy-unattached` policy would end them. Private shell persistence needs a deliberate contract.

## 4. Classify durable state and writable Git storage

**Status:** open.

Source-controlled configuration, machine-specific settings, native transcripts and disposable runtime files have different lifetimes. Their guest paths overlap and require an explicit layout.

A truly read-only canonical clone cannot also receive ordinary linked-worktree Git metadata writes. Options include writable private clones or another approved storage arrangement. Teardown must preserve required and unpushed work or refuse removal.

The broader workstation requires a durable Schedule workspace. This proposal must meet that requirement when integrated; calling a worktree ephemeral does not decide its retention policy.

## 5. Trust and credentials

**Status:** open.

Guest trust, GitHub access, hosted-model credentials and Remote Control authentication need an approved delivery mechanism. The host's macOS keychain is not itself a Linux guest credential store.

**Consequence:** unattended sandbox startup cannot be claimed until authentication, trust and recovery are qualified for the selected deployment.
