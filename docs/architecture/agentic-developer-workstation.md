---
title: "Agentic developer workstation"
type: RFC
status: Draft
created: 2026-11-11
updated: 2026-11-20
---

# Agentic developer workstation

The workstation gives a developer five persistent agent roles inside a schedule's SBX sandbox. Desktop and iPad editors open views of those roles through shell profiles. Work, conversation identity and evidence survive short PR cycles and device changes.

This is a proposed system design. The [roadmap](../roadmaps/agentic-developer-workstation.md) defines delivery and qualification; the [decision companion](agentic-developer-workstation.decisions.md) records significant choices and open questions.

<a id="1-problem"></a>

## 1. Problem and goals

Engineering work outlives the terminal, device and branch used to start it. A device change can interrupt an investigation, hide a pending question or cause another session to repeat work. Frequent merges can discard useful context if the environment is tied to a PR.

A schedule changes as design, implementation and tests reveal work. The developer needs continuity across those amendments while retaining control over assignments, approvals and consequential actions.

Conversation summaries alone cannot preserve the original reasons, rejected alternatives, uncertainty or verification results. The system needs durable work, access to original evidence and a documented development method exercised through realistic scenarios.

<a id="2-goals-and-scope"></a>

### 1.1 Goals

| ID | Goal | Observable result |
| --- | --- | --- |
| R1 | Preserve human direction | Assignments, approvals, amendments and consequential actions retain their authority and source |
| R2 | Keep continuity across a schedule | PR cycles preserve its environment, role identities, unfinished work and useful sessions |
| R3 | Support five roles on three hosts | Designer, planner, coder, compliance auditor and reviewer have separate contexts on Claude, Codex or OpenCode inside SBX |
| R4 | Work across devices | Desktop and iPad editors open profiles onto the same running roles |
| R5 | Use original evidence while working | Scoped retrieval returns exact sources, citations, surrounding context and visible gaps |
| R6 | Load governing instructions | Roles load the approved common and role reading sets at startup and after compaction |
| R7 | Deliver accepted engineering changes | Early findings, checks of the exact candidate, independent closing review and Owner sign-off support delivery |
| R8 | Use DevLore for lifecycle management | Environment and service operations preserve their durable identities |
| R9 | Use available resources | Hosted models and existing machines support the initial deployment |
| R10 | Establish the methodology | Reviewed scenario evidence produces procedures and supporting tools that work on real assignments |

## 2. Constraints and scope

The initial deployment uses hosted models and existing access. The available machines are a Mac mini and a Minisforum system; the Minisforum shares capacity with centralized logging. Platform support, versions and resource budgets require qualification. Logging-system design is outside this work.

[Local inference and capacity qualification (#515)](https://github.com/NobleFactor/noblefactor-engprod/issues/515) owns any later model serving, benchmarks, hardware selection or procurement. Those outcomes are separate from this roadmap's completion criteria.

GitHub remains authoritative for issues, schedules, scenarios, source and PRs. The shared [engineering process](../engineering/process.md) governs approvals, plans, Git operations and repository writes. Runtime access and passing checks grant no additional authority.

All role hosts run inside the schedule sandbox. Review independence requires appropriate model families and permissions; different role names or prompts inside one sandbox do not create a filesystem security boundary.

## 3. System context

| External system or owner | Relationship |
| --- | --- |
| Developer devices | Connect to the launcher and authenticated editor services |
| GitHub | Supplies planning and source authority; receives approved issue, schedule and PR changes |
| Hosted model services | Serve the selected native hosts within authorized account access and quotas |
| [Agent-assisted engineering (#456)](https://github.com/NobleFactor/noblefactor-engprod/issues/456) | Owns roles, host drivers, sandbox requirements and closing-review methodology |
| [Engineering evidence archive (#490)](https://github.com/NobleFactor/noblefactor-engprod/issues/490) | Owns capture, catalog/provenance, retrieval, checkpoints, protection and recovery |
| [Engineering handbook, agent rules and skills (#526)](https://github.com/NobleFactor/noblefactor-engprod/issues/526) | Owns governing process, role reading sets, host entry points, standards and skills |
| [Agentic workstation integration (#514)](https://github.com/NobleFactor/noblefactor-engprod/issues/514) | Owns the integrated developer experience, continuity, workspaces, compliance and operations |
| DevLore | Owns the lifecycle resource and control-plane contracts used to manage environments and services |

The human access path is device → editor backend inside SBX → role shell profile → guest-side role-view launcher → native session. Native host listeners remain private to SBX. Control-plane management uses the SBX/driver boundary independently of an editor connection.

<a id="3-our-solution"></a>

## 4. Solution strategy

A committed schedule has one logical environment and one active SBX sandbox. The environment keeps its identity across a replacement runtime. It holds on-demand role sessions, selected native host servers, editor backends and a durable private workspace. PR worktrees, assignments, terminals and device connections have shorter lifetimes.

A durable binding maps each environment/role to one selected host-server instance and native conversation ID. First use creates a never-created role once; subsequent views attach to or resume that conversation. Routine recovery preserves its native identity. Replacement follows the [approved succession contract](#84-session-succession).

Native host servers own their sessions, primary agents and delegated execution. The control plane manages server lifecycle and durable bindings through the common drivers. Editors own terminal clients and presentation. Additional views reuse the same role session.

The launcher, access routing, policy distribution and private archive run outside schedule sandboxes. Their logical separation permits them to remain available when a sandbox stops; they may share a physical machine with SBX.

Design can begin under an existing Epic or Feature before an execution schedule exists. The designer supplies the architecture and roadmap; the planner proposes issues, plans and schedules. The runtime representation of that design context remains [D1](agentic-developer-workstation.decisions.md#d1).

<a id="5-system-architecture"></a>

<a id="51-components-and-placement"></a>

## 5. Components

```mermaid
flowchart TB
    Mac["Desktop editor<br/>VS Code or compatible client"]
    Pad["iPad Pro browser"]
    GitHub["GitHub: issues, scenarios, schedules<br/>Source and PRs"]
    Models["Hosted model services"]

    subgraph Shared["Engineering services outside schedule sandboxes"]
        Control["Launcher and control plane<br/>Environment and role/session bindings<br/>DevLore lifecycle management"]
        Access["Authenticated access and connection routing"]
        Policy["Approved handbook, rules, skills and role reading sets"]
        Config["Environment configuration<br/>Role hosts, models and resource revisions"]
        Evidence["Private evidence capture and scoped retrieval"]
        Catalog[("PostgreSQL catalog and provenance")]
        Originals[("Original records, artifacts and checkpoints<br/>Storage layout to decide")]
        Evidence --> Catalog
        Evidence --> Originals
    end

    subgraph SBX["One SBX sandbox for one scheduled environment"]
        EditorA["Editor server A: desktop connection"]
        EditorB["Editor server B: browser connection"]
        ProfileA["Shell from role profile A"]
        ProfileB["Shell from role profile B"]
        Attach["Role-view launcher and common host drivers<br/>Resolve role to server and native session ID"]

        subgraph Servers["Selected native host servers"]
            Claude["Claude server"]
            Codex["Codex app-server"]
            OpenCode["OpenCode server"]
        end

        subgraph Managed["Sessions and execution managed by the native host"]
            Roles["Role sessions created on demand<br/>Designer, Planner, Coder, Auditor, Reviewer"]
            Primary["One primary agent per role session"]
            Children["Optional sub-agents and helper processes"]
            Roles --> Primary
            Primary -->|"Delegates through its native host"| Children
        end

        Work[("Durable schedule workspace<br/>and capture spool")]
        EditorA --> ProfileA
        EditorB --> ProfileB
        ProfileA --> Attach
        ProfileB --> Attach
        Attach -->|"Attach to assigned session"| Claude
        Attach -->|"Attach to assigned session"| Codex
        Attach -->|"Attach to assigned session"| OpenCode
        Claude -->|"Owns assigned sessions: 1:N"| Roles
        Codex -->|"Owns assigned sessions: 1:N"| Roles
        OpenCode -->|"Owns assigned sessions: 1:N"| Roles
        Primary --> Work
        Children --> Work
    end

    Mac --> Control
    Pad --> Control
    Mac --> Access
    Pad --> Access
    Access --> EditorA
    Access --> EditorB
    Control -->|"Manage environment and host-server lifecycle"| SBX
    Control <--> GitHub
    Policy -->|Requirements and resource references| Config
    Config -->|Approved role settings| Control
    Policy --> Primary
    Policy --> Children
    Primary <-->|"Scoped evidence retrieval"| Evidence
    Work -->|"Incremental capture"| Evidence
    Claude --> Models
    Codex --> Models
    OpenCode --> Models
```

The role-session group represents five contexts distributed among selected hosts. It does not require a copy of every role on every host. A native server can serve several roles; its internal mapping of agents to operating-system processes is host-specific.

<a id="41-persistent-specialists"></a>

### 5.1 Roles

| Role | Work it leads | Authority boundary |
| --- | --- | --- |
| Designer | Problem, goals, architecture, interfaces, workflow, and roadmap | Proposes design; edits authorized design assets |
| Planner | Issue decomposition, dependencies, proposed schedules, and amendments | Proposes commitments; applies only authorized tracker changes |
| Coder | Implementation, debugging, tests, and correction of findings | Writes the assigned workspace within current authorization |
| Compliance auditor | Standards checks, early findings, and final compliance evidence | Reads identified source/policy and records findings; does not rewrite the implementation it audits |
| Reviewer | Correctness, regression risk, design fit, and verification | Reviews identified inputs independently and participates in closing review |

Roles remain available for iterative work. A designer can revisit an interface during coding, and a planner can amend proposed work after a test exposes a dependency. [Roles (#460)](https://github.com/NobleFactor/noblefactor-engprod/issues/460) and the closing-review contract define authority and independence.

<a id="53-common-host-driver-contract"></a>

### 5.2 Native host drivers

[Agent hosts (#459)](https://github.com/NobleFactor/noblefactor-engprod/issues/459) owns the common Claude, Codex and OpenCode driver model. The role-view launcher consumes that contract.

Drivers discover or start the selected server, then address a role by native ID. Serialize server startup by environment/host identity and role creation by environment/role identity. Persist creation intent before asking the host to create a session. After a lost reply, discover the result or report an unresolved operation before another creation is allowed.

Qualify native startup auto-creation and per-session configuration. A server-created conversation becomes a role only after its identity and approved configuration are associated with the authoritative binding.

Each driver reports support and failure behavior for discovery/start, attach/detach, history/events, input/interruption, approvals, policy loading, checkpoints/compaction, resume and replacement. It distinguishes temporary unavailability, repairable resume faults and exhausted native-state restoration. Unsupported behavior remains visible.

| Host | Primary reference | Qualification needed |
| --- | --- | --- |
| Claude | [Remote Control](https://code.claude.com/docs/en/remote-control) documents multi-session server and single-session modes | Approved per-role configuration, editor-launched native attachments, simultaneous views, approvals, disconnection and recovery |
| Codex | [App-server](https://learn.chatgpt.com/docs/app-server) supplies independent threads and event subscriptions | Shared-server context separation, simultaneous native TUIs on one thread, approval/input handling, no-view execution and recovery |
| OpenCode | [Background service](https://opencode.ai/docs/cli/#background-service) owns sessions and execution for shared clients | Per-role configuration, simultaneous views of one session, capture, compaction and recovery |

The documented foundations do not demonstrate the proposed SBX/editor integration. Codex can unload a thread after its last subscriber leaves; qualify a continuity strategy, such as a retained driver subscription. Protocol subscriptions alone do not prove simultaneous native TUI support.

Pin host releases, model/provider settings, instructions and tool/check environments. Restore only authorized model access. Quota exhaustion or a connection failure cannot silently select a billable fallback.

<a id="54-editor-instances-and-attachment-views"></a>

### 5.3 Editors and profiles

Designer, planner, coder, auditor and reviewer profiles identify a logical role, guest workspace and common role-view entry point. Bindings resolve mutable host/session IDs; device configuration does not embed those IDs or credentials. Each open creates its own terminal presentation.

An editor service owns its backend, device connections, terminals and attachment clients. A transient reconnect resolves the intended backend. An additional device can use another independently configured backend inside the same sandbox.

```mermaid
sequenceDiagram
    participant Mac as Desktop editor
    participant A as Editor server A
    participant Host as Existing role session
    participant B as Editor server B
    participant Pad as iPad browser editor
    Mac->>A: Open designer shell profile
    A->>Host: Guest-side launcher resolves binding and attaches
    Host-->>A: Current history, events and pending questions
    A-->>Mac: Terminal view
    Pad->>B: Open the same designer profile
    B->>Host: Another guest-side client attaches to that binding
    Host-->>B: Current history, events and pending questions
    B-->>Pad: Independent terminal view
    Mac->>A: Disconnect desktop editor
    Note over A,Host: Agent lifetime remains under environment supervision
    Pad->>B: Continue authorized interaction
    B->>Host: Local profile client forwards input
```

[VS Code Remote Tunnels](https://code.visualstudio.com/docs/remote/tunnels/#can-multiple-users-or-clients-access-the-same-remote-instance-simultaneously) limits a server instance to one user/client at a time. Independent instances are the proposed topology for simultaneous devices. [Coder code-server's iPad support](https://coder.com/docs/code-server/ipad) is another candidate, with [different extension availability](https://coder.com/docs/code-server/FAQ). Product choice, coexistence, routing and separate runtime state remain [D2](agentic-developer-workstation.decisions.md#d2).

Publish authenticated editor endpoints. Keep native agent endpoints on guest-local interfaces or protected Unix sockets. Profiles receive only their authorized context and credential references. Qualify actual iPad keyboard shortcuts, interruption, clipboard, focus, resizing, suspension and reconnect behavior. Layouts and terminal dimensions remain client-local.

<a id="55-shared-evidence-archive-and-policy"></a>

### 5.4 Evidence and policy services

The archive runs outside schedule sandboxes with its own service identity and durable storage. PostgreSQL is the preferred catalog, provenance and full-text platform. Placement of large originals remains the archive owner's decision.

A protected permanent capture spool holds available transcripts, tool calls/results, attachments and work artifacts incrementally. Preserve originals, source identity/ranges, hashes, parser versions, capture watermarks and explicit gaps before deriving indexes or summaries. Capture is idempotent. Local durable acknowledgment and backup recoverability are separate facts.

Retrieval offers scoped search, bounded results, exact-source reads, citation resolution and surrounding-context expansion. Authorization covers snippets, counts, artifacts and expanded context. Ordinary readers have read-only access; agents use the scoped API rather than raw archive mounts or unrestricted database credentials. The archive owns retention, redaction, deletion, backup and index rebuilding.

The handbook supplies approved common/role reading sets and host entry points. Evidence explains prior work; extracted claims become policy through review. [Role entry points (#528)](https://github.com/NobleFactor/noblefactor-engprod/issues/528) owns measured startup/post-compaction reading. Required reading changes through that review process.

<a id="environment-role-configuration"></a>

### 5.5 Environment role configuration

Each environment has a versioned configuration applied to its active SBX sandbox. It identifies the Schedule, each role's approved host and model settings, its workspace, and references to common context, role instructions and skills. Shared defaults support consistent setup; environment choices remain subject to the shared requirements.

| Record | Responsibility and location |
| --- | --- |
| Shared policy and defaults | The handbook and shared role resources define responsibilities, audit scope, independence, triggers and authority; policy distribution runs outside schedule sandboxes |
| Environment configuration | The control plane retains the approved configuration and its source revision outside the sandbox and makes the applicable settings and resources available inside it |
| Role binding and observed state | The control plane retains the selected daemon, original conversation ID, binding revision, actual model and loaded resource evidence for each environment/role |
| External review and audit records | The PR introducing the changes holds the external reviews, findings and corrective verification; review text is kept outside repository commits |

The control plane uses DevLore to manage the environment and selected native hosts. Each role resolves through one authoritative environment/role binding. Host selection is a setting in that binding, not a second identity under which another copy of the role can be created. Additional terminal views attach to the same native conversation.

Configuration states the intended model; the host reports the model actually used. Record provider, model identifier and family against the affected work. The Compliance auditor must use a different model family from every builder of the candidate. A distinct host name or role label does not establish that independence. If the configured auditor is ineligible or its model is unknown, report the conflict to the Owner and retain the existing binding while it is resolved.

Reviewed settings changes follow [I7](#i7-configuration-native-session-controls-and-delegation). Compatible changes preserve conversation identity. A different host preference does not authorize a new role conversation or bypass [session succession](#84-session-succession). The [configuration decision](agentic-developer-workstation.decisions.md#w6) records the responsibilities; file formats and implementation steps belong in the delivery plan.

<a id="58-interaction-lifecycle"></a>

## 6. Runtime and development workflow

The runtime distinguishes environment readiness, editor access, server readiness, conversation identity, execution and views. The following interactions define the required outcomes; the [roadmap's acceptance cases](../roadmaps/agentic-developer-workstation.md#interaction-acceptance-cases) define their demonstrations.

<a id="4-development-workflow"></a>

### 6.1 Development workflow

<a id="42-begin-with-design-before-scheduling"></a>

<a id="43-move-from-designer-to-planner"></a>

#### 6.1.1 Design and planning

The developer brings a problem to the designer, who reads requirements and evidence and produces the architecture, workflow, roadmap, scenario proposals and bounded questions. The Owner reviews them. The handoff identifies accepted requirements, remaining proposals, interface owners, dependencies and the first useful increment.

The planner proposes Tasks/Bugs under their owning Features, retains cross-owner dependencies, and creates one or more bounded schedules through the approved process. Each issue receives its plan before work begins.

A Scenario describes an experience; a Schedule orders the Tasks/Bugs that advance or walk it. [Portable tooling (#152)](https://github.com/NobleFactor/noblefactor-engprod/issues/152) and its [project-membership record](https://github.com/NobleFactor/noblefactor-engprod/issues/152#issuecomment-6661940131) illustrate a journey spanning owners while discovered work moves into Triage or schedules with its origin retained. Apply the [current Scenario model](../issue-standards.md#scenarios).

The first proposed schedule walks selected scenarios and records gaps in tooling and method. Its steps are Tasks/Bugs linked to persistent Scenario records. The [Scenarios project](https://github.com/orgs/NobleFactor/projects/27/views/2) is the team's collection; roadmap scenario IDs identify proposed narratives, not filed records.

<a id="44-start-and-work-a-scheduled-environment"></a>

#### 6.1.2 Scheduled work

The developer selects an Owner-approved schedule. The control plane resolves its environment and starts or resumes SBX. Opening a role profile resolves its server and session binding through I1/I2.

Before tool use, the role loads required common/role instructions and its source, plan, permissions and checkpoint. The incident record supplies evidence rather than compulsory startup reading.

The developer opens useful roles, inspects source/diffs and gives bounded assignments. The coder implements/tests; the designer answers design questions; the planner proposes scope changes; the auditor records findings and rechecks corrections; the reviewer assesses identified results independently. Disconnection leaves the same authority and pending approvals in force.

<a id="45-leave-the-desktop-and-continue-from-an-ipad"></a>

#### 6.1.3 Change devices

A developer can leave two role views open on desktop VS Code and open the same environment in an iPad browser editor. A guest-side profile attaches to the existing role's native session. Both devices can show current conversation, progress, source state and pending questions while keeping independent layouts.

Several views do not fork a conversation. Their input ordering, duplicate handling and approval routing follow the qualified driver contract rather than an assumed single-controller restriction.

<a id="46-compact-recover-and-continue"></a>

#### 6.1.4 Compaction and continuity

During work, roles retrieve relevant prior evidence and follow citations to originals. Before a supported compaction, capture outstanding evidence, consult prior sources and review a durable checkpoint containing decisions/reasons, rejected alternatives, uncertainty, verification references, pending operations, unfinished work and the next action.

After compaction, reload current reading and continue the same session. [Checkpoint integration (#494)](https://github.com/NobleFactor/noblefactor-engprod/issues/494) owns the record; host drivers supply provider operations. Crashes and automatic compaction may bypass cooperative hooks, so continuous capture and explicit gaps remain necessary.

<a id="47-merge-increments-and-finish-the-work"></a>

#### 6.1.5 Merge and completion

A tested increment follows the approval and PR process. Final compliance evidence identifies the exact candidate; changed source, policy, dependencies or check environment can invalidate it. Frequent merges preserve useful sessions and the schedule environment.

[Closing review (#457)](https://github.com/NobleFactor/noblefactor-engprod/issues/457) owns the independent audit/review and Owner sign-off needed for Feature closure. Early audit, a commit gate or CI does not establish that closure.

At schedule completion, reconcile unfinished work and pending operations, preserve work/evidence and release runtime resources under lifecycle authority. Schedule completion, Feature closure, shutdown and retention are separate decisions.

<a id="states-that-matter"></a>

<a id="interaction-ownership-and-durable-records"></a>

### 6.2 States and operation records

| Dimension | States to distinguish | Why it matters |
| --- | --- | --- |
| Environment and SBX | Stopped, starting/restoring, ready, unavailable, retired | The editor and native hosts need the selected environment and its permanent workspace |
| Editor server | Absent/stopped, starting, ready, failed | A browser or desktop client being open does not establish that its backend is ready |
| Client connection | Disconnected, connecting/authenticating, connected | An editor server can continue without any connected developer device |
| Selected native host server | Stopped, starting, ready, unreachable, failed | One server can own several roles; an unreachable server is not proven absent |
| Durable role binding | Never created, creation in progress, bound, recovery blocked | Only confirmed first creation may allocate a new role conversation |
| Session execution | Unloaded/stopped, idle, working, awaiting approval, interrupted, unavailable | An existing conversation may need resume or repair while preserving its native identity |
| Terminal view | None, attaching, attached, disconnected; possibly several views | Opening or closing presentation does not create or end the role conversation |

Check authority, approved configuration, pending operations and service availability alongside these states. An unreachable service is not proven absent; a retired environment requires authorized reactivation.

| Owner | Authoritative responsibility | Information retained for these interactions |
| --- | --- | --- |
| GitHub | Schedule, issue, plan, and accepted source/workflow authority | Existing native planning records; the runtime stores references |
| Lifecycle manager/control plane | Environment and host-server desired state, active runtime binding, role-to-session binding, and consequential operation intent/outcome | Stable target IDs, binding revisions, configuration references, operation IDs, actor/authority references, and observed results |
| Native host server | Conversation history, turn execution, approvals, and session-owned sub-agents/helper processes | Native session/turn/request IDs and execution outcomes, exposed through its driver |
| Editor service | Backend instance, client connection, shell/terminal process, and attachment lifetime | Environment/client/backend/view IDs and the role/session binding used for attachment |
| Capture/archive services | Preserved originals, capture completeness, source-linked checkpoints, and recovery evidence | Original locators, hashes, watermarks, explicit gaps, and archive receipts |

Before consequential create/start/stop/submit/approve actions, retain an operation ID, target, expected binding revision, actor/authority reference, requested action and pending state. Record the observed native result and evidence. Repeated requests with the same operation ID resolve that operation. A different ID cannot evade coordination on the same server or role.

Each attachment carries role, server, native ID and binding revision. Validate the revision when attaching or acting; resolve a superseded binding again. Execution status comes from the native host. Unknown outcomes remain visible until readback establishes what happened.

<a id="eight-stable-startup-combinations"></a>

### 6.3 Startup combinations

Make SBX and its permanent workspace ready first. In this table, E means the intended editor backend is ready, D means the selected native server is ready, and B means a role has a recorded conversation binding. B describes stored identity rather than a running process.

| E | D | B | Required path for opening the role |
| --- | --- | --- | --- |
| No | No | No | Start editor; profile ensures host server; create role session once, persist binding, attach |
| No | No | Yes | Start editor; profile restarts host server; resume recorded session, attach |
| No | Yes | No | Start editor; profile creates role session on existing host server, persists binding, attaches |
| No | Yes | Yes | Start editor; profile attaches to or resumes recorded session on existing host server |
| Yes | No | No | Existing editor/profile starts host server, creates role session once, persists binding, attaches |
| Yes | No | Yes | Existing editor/profile restarts host server, resumes recorded session, attaches |
| Yes | Yes | No | Existing editor/profile creates role session once, persists binding, attaches |
| Yes | Yes | Yes | Existing editor/profile attaches to or resumes recorded session; create no new role conversation |

Only an authoritative never-created state permits first creation. Reconcile starting, missing and uncertain records before using a stable row. Reuse intended instances; allocate another editor backend only when its product/client routing requires one. Each path ends in an attachment or an explicit pending, unavailable or recovery state.

<a id="start-or-attach-activity"></a>

<a id="interaction-catalog"></a>

### 6.4 Environment and role startup

<a id="i1-prepare-the-environment-and-editor"></a>

#### 6.4.1 I1. Prepare the environment and editor

Authenticate the developer and resolve the requested environment/schedule and editor connection. Read desired state and the active runtime binding. Reuse a ready environment; join an existing startup; start a confirmed stopped environment when authorized. Discover an unreachable runtime before replacing it.

Restore the permanent workspace and intended editor backend. Reconnect to an existing backend after a transient loss; allocate another for an additional device when required. Record backend identity/routing, make reviewed profiles available and establish the authenticated connection.

The developer can browse work before starting any role. Authentication, storage or startup failures return a specific pending/blocked state and operation ID. Repeated opens reconcile that operation and backend.

<a id="i2-create-or-resume-a-role-including-concurrent-opens"></a>

#### 6.4.2 I2. Create or resume a role

The profile supplies logical environment/role identity. Resolve its approved environment configuration, ensure server readiness under environment/host coordination, then read binding and creation intent under environment/role coordination.

For a never-created role, record one intent and request creation with approved context. Associate any native startup-created session with that intent and role configuration. Persist the confirmed native ID and binding before reporting ready. If creation succeeds but binding persistence fails, retain the pending operation and reconcile it before another creation.

For a bound role, attach if live or resume its original ID if stopped/unloaded. Preserve active work and approvals, load required instructions before tools, and send resume faults to I6. Return one binding to waiting opens and create their separate attachments.

An abandoned request, expired coordination claim or coordinator restart changes who reconciles the operation; it does not prove creation never happened. If the driver cannot determine a lost creation outcome, keep creation blocked with the same operation ID.

```mermaid
sequenceDiagram
    participant A as Editor profile A
    participant B as Editor profile B
    participant L as Lifecycle and host driver
    participant H as Native host server
    A->>L: Open coder
    B->>L: Open the same coder
    L->>L: Coordinate server startup and resolve role state
    L->>L: Persist one first-creation intent
    L->>H: Create role for that intent with startup context
    alt Native session ID confirmed
        H-->>L: Native session ID
        L->>L: Persist authoritative role binding
        L-->>A: Binding to the recorded native ID
        L-->>B: The same binding
    else Creation reply lost
        L->>L: Retain pending intent and unknown outcome
        L->>H: Discover the outcome of that creation
        alt Existing session identified
            H-->>L: Confirmed native session ID
            L->>L: Persist or reuse its binding
            L-->>A: Binding to the confirmed native ID
            L-->>B: The same binding
        else Outcome remains unresolved
            L-->>A: Creation pending; retain operation ID
            L-->>B: The same pending operation
        end
    end
```

```mermaid
flowchart TB
    Open["Open a role through the launcher and editor profile"]
    Environment["Ensure selected SBX and permanent workspace are ready"]
    Editor["Ensure editor backend and authenticated client connection"]
    Host{"Selected native host server ready?"}
    StartHost["Serialize startup or reconcile existing server state"]
    HostReady{"Server ready after reconciliation?"}
    Binding{"Resolve durable role state<br/>under environment/role coordination"}
    Intent["Record first-creation intent"]
    Create["Ask native host to create role session<br/>with approved startup context"]
    Created{"Native session ID confirmed?"}
    Reconcile["Discover the existing creation outcome<br/>never blindly create again"]
    Known{"Created session confirmed?"}
    Save["Persist native ID and authoritative binding"]
    Existing{"Recorded session available?"}
    Resume["Resume original native session ID"]
    Resumed{"Original session restored?"}
    Attach["Attach local terminal client to authoritative session"]
    Recovery["Preserve binding and attempt original-session recovery<br/>Use S8 if restoration is exhausted"]
    Blocked["Report starting, unavailable, or recovery state<br/>retain operation identity and role binding"]

    Open --> Environment
    Environment --> Editor
    Environment -->|"Unavailable or restoring"| Blocked
    Editor --> Host
    Editor -->|"Connection or startup blocked"| Blocked
    Host -->|"Yes"| Binding
    Host -->|"No"| StartHost
    StartHost --> HostReady
    HostReady -->|"Yes"| Binding
    HostReady -->|"No"| Blocked
    Binding -->|"Never created"| Intent
    Intent --> Create
    Create --> Created
    Created -->|"Yes"| Save
    Created -->|"Response lost or outcome uncertain"| Reconcile
    Binding -->|"Creation pending or unknown"| Reconcile
    Reconcile --> Known
    Known -->|"Yes"| Save
    Known -->|"Unresolved"| Blocked
    Binding -->|"Bound"| Existing
    Binding -->|"Recovery blocked"| Recovery
    Existing -->|"Active or idle"| Attach
    Existing -->|"Stopped or unloaded"| Resume
    Existing -->|"Unavailable"| Recovery
    Resume --> Resumed
    Resumed -->|"Yes"| Attach
    Resumed -->|"No"| Recovery
    Save --> Attach
    Save -->|"Binding persistence failed"| Blocked
    Recovery --> Blocked
```

<a id="i3-attach-reconnect-and-release-terminal-views"></a>

### 6.5 I3. Views and reconnect

An editor terminal invokes the guest-side client with the logical role. Resolve and validate the binding, attach to its native ID, and obtain available history, current status and pending questions. Reconcile history and live events using supported cursors or state refresh; identify unavailable intervals.

Additional views follow the same path with independent presentation. Approved recovery can change the binding, which must be resolved before further actions. Closing a terminal releases that attachment. Editor failure reconnects through I1; neither event changes role authority or desired execution.

When the last human view closes, supervision and the qualified continuity path preserve authorized work. An idle runtime may unload while its conversation remains stored; a later open resumes its original ID. Reconnection does not resubmit assignments or inputs with unknown outcomes.

```mermaid
sequenceDiagram
    participant A as Desktop editor and profile
    participant B as iPad editor and profile
    participant D as Role attachment driver
    participant H as Native host server
    A->>D: Attach to coder
    D->>H: Attach to recorded native ID
    H-->>D: History, current status and pending questions
    D-->>A: Current role view
    A--xD: Connection lost
    Note over D,H: Role work and authority remain unchanged
    B->>D: Open the same coder profile
    D->>H: Resolve current binding and attach
    H-->>D: Current state and available history
    D-->>B: Independent view of the same conversation
    A->>D: Reconnect with known role/view identity
    D->>H: Reconcile history and live events
    D-->>A: Refreshed view; preserve uncertain submissions
```

<a id="i4-work-and-approvals-across-views"></a>

### 6.6 I4. Work and approvals

| Action or observed state | Concrete interaction and resulting state |
| --- | --- |
| Open a view while the role is working | Read current progress/history; keep the same active assignment and native ID |
| Submit new input | Record submission identity and binding revision; forward through the host's supported ordering/queue contract; return accepted, queued, rejected, or unknown |
| Lose the submission reply | Read back the native turn/result where identifiable; keep an unknown outcome visible when it cannot be determined; do not automatically resubmit |
| Two views submit different inputs | Let the native host order, queue, or reject work through its published contract; show each request's result without imposing an invented single-controller restriction |
| Approval appears | Display the same native request ID, action/scope, and current outcome in every authorized attached view |
| A view answers approval | Validate its authority, current binding, and exact pending request; coordinate the answer and record the host's decision |
| Another view answers an already resolved request | Return the recorded result or stale-request response and refresh the view; do not authorize another action |
| Approval answer has an uncertain outcome | Reconcile the native request before retrying; retain pending/unknown state and grant no additional permission |
| All views disconnect with approval pending | Preserve the question and its scope; execution remains blocked where approval is required |
| Assignment completes | Record its outcome and verification references; return the conversation to its observed idle/waiting state without ending the role |

Every attached authorized view identifies the same native approval request, action/scope and result. Validate an answer's authority, binding and exact pending request. Coordinate its submission; a late answer returns the recorded result or a stale-request response. Expired requests, changed scope and superseded bindings cannot authorize another action.

```mermaid
sequenceDiagram
    participant H as Native host server
    participant D as Host driver and approval coordination
    participant A as Role view A
    participant B as Role view B
    H-->>D: Approval Q with exact scope
    D-->>A: Q pending
    D-->>B: The same Q pending
    A->>D: Answer Q under current authority and binding
    D->>D: Record answer intent and coordinate Q
    D->>H: Submit answer to Q
    H-->>D: Q resolved; action may proceed
    D-->>A: Q resolved
    D-->>B: Q resolved
    B->>D: Late answer to Q
    D-->>B: Already resolved; show recorded outcome
```

Approval resolution and action completion are separate observations. Host differences remain explicit in the capability record.

<a id="i5-stop-suspend-and-resume-at-the-intended-scope"></a>

### 6.7 I5. Stop and resume

A lifecycle request names its target and desired state.

| Target | What stops or disconnects | What remains |
| --- | --- | --- |
| One terminal view | Its terminal/attachment | Role conversation, authorized work, other views, and host server |
| One editor backend | Its client connections and terminal clients | Native host servers, conversations, durable work, and other editor instances |
| One role's execution | Its supported active-turn interruption/pause through the native host | Conversation/native ID, other role sessions, and the shared host server |
| One native host server | Execution managed by that server; every assigned role is accounted for | Role identities/history and permanent workspace; editors and other host servers |
| SBX runtime | Its editor and native host services and local execution | Stable environment/role bindings, permanent work, spool/checkpoints, and shared external services |
| Environment retirement | New work and released runtime resources under the accepted lifecycle decision | Retained work, evidence, and historical bindings under their retention policy |

For a planned server/environment stop, persist target, desired state, operation ID and binding generation. Prevent stale reconnect/start requests from reversing it. Identify affected roles, preserve available evidence/checkpoints and record unfinished or uncertain operations.

Use native stop/interruption controls and let each host manage its children. Confirm the observed result before reporting stopped. Lost contact or potentially active children require reconciliation or revocation of the old runtime's authority. A forced stop needs explicit approval and a recorded loss window.

A fresh authorized start reconciles the retained resources and original native IDs. Reload reading and inspect pending outcomes before continuing. Pending approvals stay pending. Unplanned suspension and crashes use I6.

```mermaid
stateDiagram-v2
    [*] --> Stopped
    Stopped --> Starting: Authorized start
    Starting --> Ready: Server ready and sessions discoverable
    Starting --> Unavailable: Startup outcome unresolved
    Ready --> Stopping: Authorized stop
    Stopping --> Stopped: Native host confirms execution stopped
    Stopping --> Unavailable: Stop outcome unresolved
    Ready --> Unavailable: Failure or lost contact
    Unavailable --> Starting: Confirmed stopped and start still desired
    Unavailable --> Ready: Live instance found and start desired
    Unavailable --> Stopping: Live instance found and stop desired
```

<a id="i6-recover-failures-while-preserving-identity"></a>

### 6.8 I6. Failure recovery

| Failure | Recovery interaction | Result visible to the developer |
| --- | --- | --- |
| Viewing device disconnects or sleeps | Reconnect the intended editor/backend and follow I3 | Same role/native ID, refreshed state, and unresolved inputs still identified |
| Editor backend fails | Lifecycle manager restores that backend/profile path; views reattach | Workspace and roles retain identity; affected views show reconnect progress |
| Native server is unreachable | Discover the existing instance and operation outcome before restarting | Unavailable/unknown until observed; no competing daemon or new conversation |
| Native server is confirmed stopped/crashed | Honor desired state; restart it if authorized, discover retained sessions, and reconcile interrupted work | Original native IDs resume; pending approvals and uncertain actions retain their status |
| SBX or its machine restarts | Restore the permanent workspace and active environment binding, then required services and original sessions | Recovery progress and restored identities; no assumption that old processes survived |
| Runtime replacement is needed | Reconcile/fence the old active environment binding before activating its replacement | One authoritative runtime with the retained environment/role IDs |
| Workspace or local capture storage is unavailable/full | Report the failed durability capability; block writes/transitions that require it until preserved work is secure | Existing state remains inspectable where possible; no claim of successful preservation |
| Archive/PostgreSQL connection fails | Capture into the bounded permanent spool; retry delivery and reconcile receipts on return | Capture lag/coverage and blocked archive-dependent operations; backlog delivery preserves evidence identity |
| Model/provider access fails | Preserve conversation/work; restore authorized access and reconcile the interrupted turn | Role remains identifiable with an explicit unavailable/interrupted state; no implicit fallback |
| Authentication expires | Reauthenticate the affected client/service within its existing scope | Connection or capability restored without enlarging the role's permissions |
| Binding state is missing or ambiguous | Restore binding records/manifests and compare native identities and operation receipts | Recovery blocked until the authoritative role can be established; absence is not first creation |
| Native conversation cannot be restored | Follow S8: evidence of exhausted restoration, explicit owner approval, fencing, and recorded succession | Successor identity and original relationship, reconstructed context, and explicit gaps |

Read actual source/remote outcomes before repeating interrupted effects. Recovery returns the role to its observed idle, working or approval-blocked state within existing authority. It does not automatically replay the last prompt.

<a id="i7-configuration-native-session-controls-and-delegation"></a>

### 6.9 I7. Configuration and delegation

Compare profile configuration with the binding and supported per-session settings. Apply compatible reviewed changes through the host while preserving identity. Conflicts report the current configuration and required lifecycle/design decision; they cannot silently switch hosts or allocate a replacement.

Managed clients address the recorded native ID. Native new/fork/switch controls must not silently change a role binding. Pin the attachment or enforce identity at a supported host boundary. An attachment path unable to do so remains unsupported until a controlled path qualifies.

Native delegation creates children under the primary session's assignment and permissions. Preserve parent/child identities and available evidence. A child does not become another top-level role or end its parent on completion. The control plane observes this work through the driver.

<a id="compliance-audit-flow"></a>

### 6.10 Compliance audits

An audit is requested on demand or during a commit after the existing pre-commit checks pass. The request identifies the exact changes, base and candidate versions, builder model evidence, applicable requirements and check results. The request resolves the environment's Compliance auditor through its existing role binding and checks independence before the assessment begins.

The auditor checks every changed file and all assets that might be affected, including files outside the diff. Coverage includes source code, tests, configuration, designs, plans, documentation, examples, help text, completions and man pages. The assessment follows the shared [compliance requirements](../engineering/agent-operation.md#compliance-auditing) and identifies its scope, evidence, findings and limitations.

Record the reviewed versions, actual auditor model, requirement revisions, findings and corrective verification with the PR that introduces the changes. Reports produced before a PR exists remain outside Git and are attached when that PR is opened. External review text is not committed to the repository. Changed inputs require the affected checks and findings to be rechecked; unresolved mandatory findings and missing required evidence remain visible to the Owner.

<a id="57-initial-physical-deployment"></a>

## 7. Deployment

| Machine | Candidate placement | Qualification |
| --- | --- | --- |
| Mac mini | SBX and colocated shared services | Platform support and combined role/editor/build/service load |
| Minisforum | Shared services or SBX if supported | CPU, memory, storage and I/O headroom alongside centralized logging |
| Developer devices | Desktop editor and iPad browser clients | Authentication, supported input/clipboard behavior and reconnect |

The first proof uses a qualified existing machine. Logical services do not require dedicated hardware. Resolve platform support, network access, quotas, backup destination and resource reservations before relying on the placement. The SBX machine must remain awake and reachable for live remote work.

[Sandbox persistence](https://docs.docker.com/ai/sandboxes/usage/#what-persists) depends on storage and removal behavior. Qualify the selected mounts/volumes, credentials, ports and export/restore paths. Target-specific test runners can return identified results from qualified external environments; cross-compilation does not replace runtime tests.

## 8. Shared concepts

<a id="52-identity-authority-and-lifetime"></a>

### 8.1 Identity and authority

| Object | Owner and lifetime |
| --- | --- |
| Design context | Existing epic/feature and versioned assets before schedule commitment; runtime representation remains open |
| Schedule | GitHub's durable commitment and execution order |
| Development environment | Stable schedule-scoped identity; one active SBX binding, recoverable across replacement |
| Role/agent | Logical specialist identity within the environment |
| Native host server | Claude, Codex, or OpenCode instance managing its assigned sessions and internal execution; may outlive individual views and serve multiple roles |
| Native session | Host-owned conversation/execution context; preserve its identity through routine recovery; owner-approved successor after disaster recovery exhausts restoration |
| Assignment | Bounded objective, issue/step, source, permissions, and recorded outcome |
| PR worktree | One increment's source scope; its process lifetime is shorter than the schedule's |
| Editor instance | Connection service inside SBX, with independently configured endpoints and runtime state |
| Shell/terminal profile | Editor launch configuration selecting a logical role and the common guest-side role-view entry point |
| View | Per-client attachment and presentation; may be released and recreated |
| Evidence/checkpoint | Durable, scoped record independent of device, session process, and sandbox lifetime |

GitHub owns planning. The control plane retains runtime bindings, desired/observed state and operation reconciliation; it does not become another backlog. At most one native session per environment/role is authoritative. Missing or unreachable state enters recovery without erasing the binding.

<a id="56-workspaces-verification-and-recovery"></a>

### 8.2 Durable work and verification

Canonical clones remain protected. A schedule uses a private durable workspace; its PR worktrees may share that private clone's metadata while keeping canonical metadata protected. [SBX requirements (#458)](https://github.com/NobleFactor/noblefactor-engprod/issues/458) makes source, drafts, prototypes, research, tests, findings and checkpoints permanent from creation. Classify reproducible caches and disposable scratch separately.

Auditors read identified immutable inputs; reviewers verify separate identified snapshots/working areas. Permissions enforce the required independence. Compliance receipts bind source/base, policy, dependencies, check environment, coverage and verdict. Revoke mutation authority during integration or construct an immutable candidate, then verify that integrated content matches reviewed content. Missing, stale, failed or inconclusive evidence blocks its required gate. Explicit overrides retain scope and reasons.

### 8.3 Capture and restoration

An archive outage uses bounded permanent spooling with visible lag/coverage. Block transitions requiring evidence that is not securely preserved. On return, reconcile delivery receipts and preserve evidence identity. The local spool storage engine remains undecided. Its evaluation should consider the Owner's preference for one stack end to end.

Machine sleep suspends local execution when it occurs; it is not an application checkpoint. A viewing laptop's sleep only affects its view when SBX runs elsewhere. Restore compatible workspace, configuration, archive, checkpoint and binding manifests after reboot or runtime replacement. A sandbox template alone is not a complete backup, and live processes are not assumed to survive.

Restoration has separately reviewed loss windows and recovery objectives. This design sets no numerical guarantees.

<a id="disaster-recovery-and-session-succession"></a>

### 8.4 Session succession

Restore the original native conversation first. Diagnose configuration, credentials, connectivity, mounts and host compatibility before treating restoration as exhausted. A failed resume or timeout alone does not establish loss.

When restoration is exhausted, retain the incident, original schedule/environment/role/session identity, attempted remedies, backups and evidence coverage. Present a proposed successor, host/configuration and known gaps for explicit Owner approval.

Before the successor can act, prevent the old runtime and binding from authorizing further actions. This revocation is called fencing. If fencing cannot be established, replacement remains blocked. Serialize cutover and reconcile unknown creation outcomes before retrying.

Record original/successor IDs, binding revision, approval, cutover time and evidence. Reload current role instructions, inspect the plan/worktree and reconcile pending operations. Reconstruct decisions and next actions from checkpoints and cited originals, reporting missing context. The archive supports reconstruction but cannot guarantee recoverable native state or complete context.

Views resolve the new binding; a returning old runtime does not regain authority. Retain original identity even when its conversation is lost. [Scenario S8](../roadmaps/agentic-developer-workstation.md#s8--disaster-recovery-after-loss-of-a-native-session) qualifies this contract for each host.

## 9. Significant decisions

The [decision companion](agentic-developer-workstation.decisions.md) records editor access, native server ownership, session succession and environment role configuration. It also records the proposed schedule/runtime and shared-archive choices and the unresolved D1–D6 decisions.

The [workstation delivery plan](../plans/doc/521-workstation-design.md) and [role-context plan](../plans/doc/558-role-entry-points.md) define implementation and verification work.

<a id="6-qualification-and-completion"></a>

## 10. Quality and acceptance

Qualify all three host paths and five independent roles in one SBX environment. Demonstrate shared-server context separation, all eight startup combinations, I1–I7 outcomes, simultaneous desktop/iPad views, concurrent creation and lost-response reconciliation, approvals across views, and stop/resume at the intended scope.

Exercise schedule amendments and repeated PR merges, evidence use before compaction, startup/post-compaction reading, original-session restoration, approved succession with visible gaps, and DevLore lifecycle management. Accept the methodology and its use on real assignments alongside the platform.

Exercise audit requests on demand and after pre-commit checks, including a changed asset that makes an unchanged help page, completion or man page stale. Demonstrate model-family conflicts, preservation of the existing role binding, and PR review records kept outside commits.

Measure accepted-change latency, blocking intervals, human interventions, repeated investigations, correction cycles, confirmed audit findings, false positives, known missed defects, capture gaps and recovery results. Agree numerical quality, response and recovery thresholds with the Owner before using them as gates.

Architecture handoff acceptance establishes a buildable baseline and first actionable increment for Workstation architecture and delivery plan (#521). System delivery is established through the [roadmap gates](../roadmaps/agentic-developer-workstation.md#5-delivery-waves-and-gates), with each host/editor path's capability evidence.

<a id="7-decisions-to-resolve-through-the-roadmap"></a>

## 11. Risks and open choices

| ID | Open decision | Resolution owner and evidence |
| --- | --- | --- |
| D1 | Pre-schedule runtime and transition into one or several schedules | Designer/planner under #521/#517; walk design-to-planning without inventing a schedule prerequisite |
| D2 | Editor/backend product, shell profiles, independent instances, transport, and per-client routing | #517/#520; demonstrate simultaneous desktop/iPad access, all eight startup combinations, and profile-launched role views inside SBX |
| D3 | Exact host capabilities, shared-server configuration, and input/approval behavior | #459 with #517; qualify session separation, creation discovery, native session-switch handling, and versioned failure behavior |
| D4 | Original-artifact layout, retention, and recovery acknowledgments | #490/#492/#496; scoped retrieval and a complete restore |
| D5 | Initial placement and resource budgets | #518/#520; qualify the existing machines and shared-service contention |
| D6 | DevLore lifecycle interface | DevLore lifecycle owner with #517/#520; reviewed resource and control-plane contracts |

Unknown creation/write outcomes, missing binding state, stale views, capture gaps, shared-server failures and resource contention can compromise continuity. The runtime contracts retain identity and explicit blocked states rather than silently duplicate work. Each chosen host/editor path needs evidence; a documented API does not establish a deployed capability.

The [roadmap](../roadmaps/agentic-developer-workstation.md#8-decisions-and-dependencies-to-resolve) assigns resolution gates and owners to D1–D6. Purchases, implementation plans, schedule commitments and policy adoption retain their own approval processes.

## 12. Glossary

| Term | Meaning |
| --- | --- |
| Environment | Durable schedule-scoped identity and its active SBX binding |
| Native host | Claude, Codex or OpenCode service owning conversation execution |
| Native session | Host-owned conversation identified by a persistent native ID |
| Role binding | Durable mapping from environment/role to host server and native session |
| Environment configuration | Versioned host/model choices, workspace and shared resource references for the environment's roles |
| Assignment | Bounded objective, issue/step, source, permissions and recorded outcome |
| Editor backend | Guest-side service accepting editor connections and owning terminals |
| View | One attachment's presentation of a role session |
| Capture spool | Protected durable queue awaiting archive delivery |
| Watermark | Record of how far a source has been captured |
| Fencing | Preventing an old runtime or binding from authorizing further actions |
| Checkpoint | Source-linked record of context, pending work and next action |
