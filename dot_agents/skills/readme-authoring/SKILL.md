---
name: readme-authoring
description: Use when writing, improving, auditing, or rewriting a repository README in Markdown, including getting-started/getting-the-code docs, prerequisites, local development setup, or a repo landing page for GitHub or Azure Repos.
---

# README authoring

**Announce at start:** "Using the readme-authoring skill."

Write README files in **GitHub Flavored Markdown (GFM)**, not plain text. A good README answers three human audiences ([Microsoft Learn — Create a README](https://learn.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops)) — and, increasingly, a fourth reader: the AI coding agents that work in the repo:

| Audience | Needs |
| --- | --- |
| **Users** | Run the project with minimal friction |
| **Developers** | Get the code, install prerequisites, and run it locally in dev mode from a fresh clone |
| **Contributors** | Report issues, follow conventions, open PRs |
| **AI coding agents** | Parse the repo, run unambiguous copy-pasteable commands without guessing, and follow the conventions in `AGENTS.md` / `CONTRIBUTING.md` |

## Choose mode

| User intent | Mode |
| --- | --- |
| No README or empty stub | **Create** |
| README exists but unclear, outdated, or incomplete | **Review** then **Rewrite** if asked |
| "Fix/improve/polish the README" | **Review** + targeted edits |

Before writing, read the repo: root config files, package manifests, scripts, CI, `Dockerfile`/devcontainer, existing docs, and `AGENTS.md` / `CONTRIBUTING.md` if present. **Do not invent commands** — derive every command from the codebase.

---

## Required structure

Use these sections in order. Skip a section only when it truly does not apply (e.g. no tests → say so briefly). **Getting the code**, **Prerequisites**, and **Development server** are the sections most often left out or left vague — treat them as first-class, not afterthoughts.

### 1. Introduction

- One short paragraph: what the project does and why it exists.
- Make the opening answer **what**, **why**, and **how**: what the project is, what problem or motivation it addresses, and the shortest path to trying it.
- When the repository has a clear differentiator, learning outcome, notable constraint, or planned capability, state it briefly instead of making generic claims.
- If the project has several meaningful capabilities, add a compact **Features** section near the introduction; do not turn it into an exhaustive inventory.
- Project logo/icon in the header if one exists (per repo assets); keep emoji use minimal elsewhere.
- UI projects: mention or link a screenshot/GIF (add the asset or leave a clear placeholder path).
- State dependencies (runtime, cloud services, other repos) and supported OS/platforms when relevant.

### 2. Getting the code

Do not fold this into "Prerequisites" or "Install" — readers need to find the repo before they can do anything else with it.

- The clone command, using the URL/remote actually configured for this repo (check `git remote -v`, not a guess).
- Anything non-default about the checkout: forking vs. direct clone, required SSO/PAT/SSH setup, submodules (`git submodule update --init`), LFS, monorepo subfolder-only checkouts.
- **Path gotchas**: if the remote or org name contains spaces or characters that produce an awkward local folder name (URL-encoded paths, spaces from Azure DevOps project names, etc.), call it out explicitly and give the fixed clone command (e.g. `git clone <url> local-folder-name`) — this trips up npm/node scripts, some shells, and IDE integrations.
- Alternative low-friction paths if they exist and you verified them: GitHub Codespaces, a VS Code Dev Container, a `.devcontainer/`.

### 3. Prerequisites

- Every tool required **before** install/build, each with a version and a link.
- If the repo pins a runtime version (`.nvmrc`, `.tool-versions`, Volta's `volta` block in `package.json`, `engines`, a devcontainer image tag), **say why the pin matters**, not just that it exists — e.g. a version manager avoids native-module ABI mismatches that produce cryptic runtime errors. Give the exact install command for the tools actually used (Volta, nvm, asdf, mise, etc.), per OS.
- Verification step: a command the reader runs to confirm the tool is present and pinned correctly (`volta --version`, `node --version`, `docker --version`).
- Note optional-but-recommended tools (Docker for a dependency, a CLI for a cloud service) separately from hard requirements.

### 4. Getting started (install + run)

Focus on **essential steps only**, in the order a fresh clone actually needs them:

1. Install dependencies (`npm install`, `pip install -r requirements.txt`, etc.).
2. Any required local config (`.env` from `.env.example`, secrets, local service startup) — link out if this is more than a couple of lines.
3. **Development server** — the command that runs the app in dev/watch mode, the URL/port it serves on, and what "it's working" looks like. State clearly that this is the *local development* path, distinct from a production build or deployment.
4. If the project is a library/API instead of an app: a **minimal usage snippet** with expected output so readers can verify setup, instead of a dev server.
5. Complex setup (multiple services, cloud accounts, infra provisioning): document in a separate file under `docs/` and **link** to it rather than inlining it.

### 4a. Usage and evidence

- Show the smallest useful example of the project in use: a command, API request, code snippet, expected output, or UI flow.
- For visual projects, prefer a real screenshot or GIF from the repository over a decorative image. Add meaningful alt text and keep the asset path valid.
- Document authentication or sample credentials only when the repository intentionally provides them; never include real secrets or imply that readers should share credentials.

### 5. Build, test, and deploy (developers)

- Build command for a production artifact, if different from the dev server.
- Test command(s), run after a successful build.
- Deployment, if the repo owns it (script, pipeline, `azd up`, etc.) — one command plus a link to details, not a full runbook.
- If instructions are long, split into `docs/` and link from the README.

### 6. Contributing

- Where to report bugs and request features (issues, discussions, chat).
- Coding and testing expectations; link to `CONTRIBUTING.md` if it exists — do not duplicate its content here.
- PR requirements (branch naming, reviews, CI).
- **License**: name and a link to the license file. Do not paste the license text; do not duplicate `CONTRIBUTING.md`/`CHANGELOG.md` content into the README — link to those files instead.

### Optional supporting sections

- **Badges**: include only badges that communicate useful, verifiable project health or entry points, such as CI, release, coverage, package, or license. Keep them near the title and remove stale or noisy badges.
- **Credits and references**: credit collaborators, upstream projects, tutorials, datasets, or design resources when they materially informed the project. Link to canonical sources rather than copying their content.
- **Table of contents**: add one only when the README is long enough that navigation benefits; do not add it to a short README.

---

## Create workflow

```
README progress:
- [ ] Inspect repo (remote, manifests, scripts, deps, CI, devcontainer, existing docs)
- [ ] Draft all sections, including Getting the code / Prerequisites / Development server
- [ ] Make the introduction answer what/why/how and surface differentiators or key features
- [ ] Add one verifiable usage example and relevant visual evidence when the project supports it
- [ ] Verify every command against the repo (and the actual git remote)
- [ ] Check all four audiences (users, developers, contributors, AI coding agents)
- [ ] Final pass: links, headings, assets, badges, credits, freshness, admonitions, no stale paths
```

1. Inspect `package.json`/`pyproject.toml`/`go.mod`/`Makefile`, `Dockerfile`/devcontainer, CI configs, version-pin files (`.nvmrc`, `volta` block, `.tool-versions`), and `git remote -v`.
2. Draft using the structure above; prefer commands copy-pasted from working project scripts, not paraphrased.
3. Use GFM admonitions where they earn their place — `[!NOTE]`, `[!TIP]`, `[!IMPORTANT]`, `[!WARNING]` — for the one or two things a reader most needs to not miss (a required tool, a common footgun). Don't scatter them everywhere.
4. Keep prose at **Level B2 English** — clear sentences, jargon only when standard for the stack.
5. Keep the README current with the repository: update commands, screenshots, badges, feature claims, and supported versions when the implementation changes.
6. Do not add unrelated docs files unless the user asks.

---

## Review workflow

Produce a short review before rewriting unless the user asked for direct edits only.

### Review checklist

**Introduction**
- [ ] Purpose clear in the first paragraph
- [ ] Opening answers what, why, and how
- [ ] Differentiators or meaningful features are visible without hype
- [ ] Dependencies and platform constraints stated

**Getting the code**
- [ ] Clone command matches the actual configured remote
- [ ] Any path/checkout gotchas (spaces, submodules, monorepo subfolder) called out
- [ ] Codespaces/devcontainer alternative mentioned if it exists and works

**Prerequisites**
- [ ] Every required tool listed with version and link
- [ ] Version pin (if any) explained — what breaks without it, not just "install X"
- [ ] A verification command is given

**Getting started**
- [ ] Install → configure → run, in that order
- [ ] Development server command, port/URL, and "it's working" signal are explicit
- [ ] Dev mode is clearly distinguished from build/deploy
- [ ] Library/API has a verifiable minimal example instead, if applicable

**Usage and evidence**
- [ ] A minimal command, code/API example, expected output, or UI flow is included
- [ ] Screenshots/GIFs are useful, accessible, and linked to valid repository assets
- [ ] No real credentials or secrets are documented

**Build, test, deploy**
- [ ] Fresh-clone path documented
- [ ] Build and test commands match repo scripts/CI
- [ ] Deployment (if repo-owned) has at least one verified command

**Contributing**
- [ ] Issue/feature channel linked
- [ ] Contribution rules linked, not duplicated
- [ ] License stated, not pasted in full; CONTRIBUTING/CHANGELOG not duplicated

**Optional sections**
- [ ] Badges are useful, valid, and not stale
- [ ] Collaborators and external references are credited where appropriate
- [ ] Table of contents is used only when the README is long enough to need it

**General**
- [ ] Markdown headings form a logical outline
- [ ] No broken internal links or wrong paths
- [ ] No secrets, tokens, or internal-only URLs unless the repo is private and the user expects them
- [ ] Commands were checked against the repo (not assumed)
- [ ] README claims, examples, assets, badges, and version references are current
- [ ] Emoji use is minimal; admonitions used sparingly and only where they add signal

### Review output format

```markdown
## README review: [repo or path]

### Summary
[1–2 sentences: overall quality and main gap]

### Strengths
- ...

### Issues
| Priority | Section | Issue | Suggested fix |
| --- | --- | --- | --- |
| High | Getting the code | Clone URL doesn't match `git remote -v` | Update to actual remote |
| High | Prerequisites | No mention of Node version pin | Add Volta/nvm section with reason |

### Missing sections
- [ ] ...

### Verdict
[Ready / Needs minor edits / Needs rewrite]
```

---

## Rewrite workflow

1. Complete **Review** (or an abbreviated checklist if the user wants speed).
2. Preserve accurate facts; fix structure, clarity, and commands.
3. Prefer editing `README.md` in place unless the user named another file.
4. When moving content out of the README, add links and keep the README as the entry point.
5. Show a brief summary of what changed and why.

---

## Style rules

- **Concise over comprehensive** in the README; link out for depth.
- Use fenced code blocks with language tags for commands and snippets.
- Use relative links for in-repo docs (`docs/setup.md`).
- Match the project's existing tone and naming (folder names, product names).
- One H1 title (`# Project name`); use H2 for the main sections.
- Do not duplicate large chunks from other docs — summarize and link.
- Do not overuse emoji; a project logo in the header is worth more than emoji throughout.
- Do not inline full `LICENSE`, `CONTRIBUTING.md`, or `CHANGELOG.md` content — link to the file.

---

## Inspiration (reference quality)

For structure, tone, and the "getting the code / prerequisites / dev vs. deploy" split, see:
[ASP.NET Core](https://github.com/aspnet/Home), [Visual Studio Code](https://github.com/Microsoft/vscode), [Chakra Core](https://github.com/Microsoft/ChakraCore), and the Azure Samples READMEs referenced by GitHub's [`create-readme` skill](https://github.com/github/awesome-copilot/blob/main/skills/create-readme/SKILL.md) (e.g. [serverless-chat-langchainjs](https://github.com/Azure-Samples/serverless-chat-langchainjs)) — note in particular how they separate "Get the code" (fork/clone/Codespaces/Dev Container) from "Prerequisites" from "Run the sample" (local dev vs. deploy).

For section templates, admonition syntax, Azure Repos context, and the source that informed the optional sections above, see [reference.md](reference.md).
