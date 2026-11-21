---
title: "noblefactor-engprod"
description: "NobleFactor engineering process, standards and deployed base-layer tools"
updated: 2026-11-19
---

# noblefactor-engprod

This repository supplies NobleFactor's engineering handbook, standards, templates and process tools. Its `Home/` tree is a DevLore base layer deployed with `writ`.

<a id="the-standards-claudemd-points-at"></a>

## Engineering handbook

Start with the [handbook](docs/engineering/index.md). Agents use the [common commandments and assigned role](docs/engineering/agents/commandments.md), together with mandatory repository/host instructions.

| Resource | Purpose |
| --- | --- |
| [Engineering process](docs/engineering/process.md) | Plans, review, implementation, delivery and approvals |
| [Work organization](docs/engineering/work-organization.md) | Issue ownership, schedules, dependencies and amendments |
| [Work assets](docs/engineering/work-assets.md) | Designs, plans, document links, locations and completion evidence |
| [Documentation standard](docs/standards/documentation.md) | Writing, metadata, source layout and structured decisions |
| [Coding standards](docs/standards/coding/index.md) | Shared and language-specific code requirements |
| [Templates](docs/templates/index.md) | Reusable structures for work records |
| [PR script specification](docs/guides/pr-script-template.md) | Owner-run Bash and PowerShell delivery scripts |
| [Branch protection](docs/github-branch-protection.md) | Required checks and protected-branch policy |

Repository instructions reference shared requirements and record approved local variations. The [documentation index](docs/index.md) also links designs, roadmaps and preserved review evidence.

<a id="what-is-here"></a>

<a id="the-layer-content"></a>

## Deployed layer

`Home/` mirrors the home-directory paths that `writ` deploys. It includes shell process helpers, Git workflow commands and the `com.noblefactor.ops.GitHub` extension under `Home/common/.local/share/devlore/star/extensions/`.

The extension provides these command groups:

- `star github issue open|create|move|close|reopen`
- `star github schedule report|list|get|open|create|close|reopen`
- `star github scenario list|get|open|create|close|reopen`
- `star github plan link`
- `star github triage sweep`
- `star github model get|diff|apply|backup|restore`

The [issue-model command references](docs/architecture/issue-data-model/index.md) define their contracts. `create` is another spelling of `open`, not a separate issue lifecycle. Check the installed command's help and build before using a documented operation.

<a id="the-star-work-is-not-here"></a>

<a id="tools"></a>

<a id="what-is-not-here-despite-what-this-file-used-to-say"></a>

## Product and repository tools

[devlore-cli](https://github.com/NobleFactor/devlore-cli) owns the `star` and `writ` binaries and their product documentation. This repository owns the extension and base-layer assets it deploys.

Repository-only tools live in `bin/`, with manuals in `share/man/man1/` and completions in `share/bash-completion/completions/`. They include `Test-Here`, `Test-OnHosts` and the Windows `Test-Here.ps1` entry point. Site-hosting tools belong to their owning site repository.

<a id="deploying-it"></a>

## Deployment

Use [DevLore's installation and deployment documentation](https://github.com/NobleFactor/devlore-cli#install) to register this repository as the base layer and deploy it. Team and personal layers can be registered above it. `writ` combines layer content into the home directory; a higher layer wins when layers supply the same path.

Verify the installed product's supported registration/deployment syntax rather than copy a command from a different release. Source examples and installed behavior are separate evidence.

<a id="ci"></a>

## Verification

Use the repository's Makefile targets for its checks and tests. [CI](.github/workflows/ci.yaml) runs `make check` on Linux, `make test` on macOS and PowerShell tests on Windows arm64/amd64. Preserve the `quality-gate` check name required by protection policy.

[The frontmatter checker](.github/scripts/Test-Frontmatter.sh) is the reference implementation for the shared document families. Repositories adopting that gate use the same script. Spelling, shell/Starlark checks and tests follow the current Makefile and CI configuration.

## License

Apache-2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).
