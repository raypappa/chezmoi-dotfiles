---
name: mcp-server-finder
description: Finds and evaluates MCP servers across GitHub, package registries, docs hubs, and curated indexes, then returns a ranked structured comparison table. Use when users ask for MCP servers, MCP integrations/tools, “mcp server for X”, “mcp tool for X”, or want MCP options compared before adoption.
---

# MCP Server Finder

## Quick start

1. Gather constraints: use case, runtime, auth, hosting model, license limits.
2. Discover candidates across multiple sources (not just GitHub).
3. Normalize candidate metadata into JSON.
4. Rank with `scripts/rank_mcp_servers.py`.
5. Return a ranked table plus top recommendations and caveats.

## Required output

Always return a ranked table with these columns:

`Rank | Name | Score | Confidence | Sources | Last Commit (days) | Stars | License | Transport | Auth | Docs/Examples | CI/Tests | Notes`

Then include:
- **Top 3 picks** (with reason for fit)
- **Known risks/gaps**
- **Fast fallback options** (if top picks fail constraints)
- **Install snippets** (default target: OpenCode global config)

## Workflow

### 1) Capture selection criteria

Collect only what changes selection quality:
- Primary use case (e.g., GitHub, Jira, DB, observability)
- Runtime preference (Node/Python/Go/other)
- Required transport (`stdio`, `http`, or both)
- Auth/security needs (OAuth, API key, self-hosted secrets)
- License policy (permissive-only, no AGPL, etc.)
- Maintenance bar (recent commits, release recency)

If underspecified, make smallest assumption: prefer actively maintained, permissive-licensed servers with quickstart docs.

### 2) Discover candidates across sources

Search all of these categories:
- GitHub repositories and code search
- Package registries (npm, PyPI, crates, etc. where relevant)
- Container registries / published images (if applicable)
- MCP directories / curated lists / docs hubs
- Vendor docs for official integrations

Avoid single-source shortlists.

### 3) Normalize into candidate JSON

Create a JSON array of candidate objects with best-effort fields:

```json
[
  {
    "name": "example-mcp-server",
    "repo_url": "https://github.com/org/repo",
    "sources": ["github", "npm", "directory"],
    "stars": 1200,
    "forks": 180,
    "last_commit_days": 14,
    "release_age_days": 30,
    "license": "MIT",
    "transport": ["stdio", "http"],
    "auth": ["oauth2", "apikey"],
    "has_quickstart": true,
    "has_examples": true,
    "has_ci": true,
    "has_tests": true,
    "has_security_policy": true,
    "has_signed_releases": false,
    "fit_score": 4.5,
    "notes": "Official integration"
  }
]
```

### 4) Rank deterministically

Run:

```bash
python scripts/rank_mcp_servers.py --input candidates.json --markdown ranked.md --json ranked.json
```

If user constraints are strict, pass filters:

```bash
python scripts/rank_mcp_servers.py --input candidates.json --require-transport stdio --require-license MIT,Apache-2.0 --top 10
```

### 5) Report

Use the ranked output. Do not reorder manually unless you explicitly explain why.

### 6) Provide install snippets (OpenCode by default)

When sharing installation/setup snippets, default to **OpenCode** unless the user asks for another client.

- Preferred target config: `~/.config/opencode/opencode.jsonc`
- Preferred mechanism: **opencode-config tool** (use this first when available)
- If tool-based update is unavailable, provide a manual JSONC edit snippet for the same file and clearly mark it as manual fallback.

Always include:
- exact file path,
- whether snippet is global or project-local,
- restart/reload step if required.

## Scoring policy

The script scores each candidate from 0-100 with weighted criteria:
- Maintenance & release freshness
- Adoption signals
- Documentation readiness
- Engineering quality (CI/tests)
- Security posture (license/security policy/signing)
- Use-case fit (`fit_score`)

Missing values are treated conservatively and lower confidence.

## Guardrails

- Do not treat popularity alone as quality.
- Prefer official/vendor-backed servers when fit is equal.
- Flag stale or weakly maintained candidates even if highly starred.
- Flag unknown license/auth posture as risk.
- If evidence is thin, say so explicitly in Confidence/Notes.
