---
name: commit
description: Use when the user asks to create a git commit, commit changes, or prepare a Conventional Commit from the current worktree. Validate the repository, stage only the intended changes, prefer a Jira reference when available, propose the message for confirmation unless the user also requests push, and commit with a non-empty body.
version: 1.2.0
author: OpenCode
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [git, commits, conventional-commits, jira]
    related_skills: []
---

# Commit Skill

I treat a commit as a durable record of intent, not a place to hide unfinished
work. I use the session context to separate my changes from work that was
already present, then stage at hunk and line granularity. A changed file is not
evidence that every changed line belongs in my commit. I inspect what is
actually staged, keep the commit atomic, and stop when the repository or the
message has an unresolved ambiguity. I never push automatically; pushing is a
separate operation that requires an explicit user request.

## Tool-first Git Operations

Use the most specific available tool for every Git operation. Do not run a Git
command through Bash when a dedicated tool supports it.

- Repository root: use the read-only Git command tool for
  `git rev-parse --show-toplevel`; no more specific tool is available.
- Status: use `git_git_status`.
- Diffs: use `git_git_diff`.
- History and recent commit subjects: use `git_git_log`.
- Current branch: use `git_git_branch` with `mode: "show-current"`.
- Staging: use `git_git_add` when path-level staging is safe.
- Commit: use `git_git_commit`.
- Post-commit inspection: use `git_git_show` and `git_git_status`.
- Remote inspection: use `git_git_remote`.
- Push: use `git_git_push`, only after an explicit push request.

There is no dedicated tool for interactive hunk staging, applying an edited
patch, or staging some binary/rename changes. Only for those cases, use the
shell tool with a narrowly scoped Git command after confirming that no
appropriate Git tool exists. Never use `git add .`.

## Workflow

Follow this sequence whenever the skill is invoked.

### 1. Interpret input

- Treat a supplied argument as a requested message hint, not as permission to
  skip safety checks.
- If the user supplied a simple message, use it to guide the generated subject
  and scope, then still inspect the diff and add the required body and a Jira
  footer when a clear key is available.

### 2. Resolve the repository and establish the baseline

- Resolve the repository root with `git rev-parse --show-toplevel` using the
  read-only Git command tool. Run all later operations relative to that root.
- Before validation or staging, capture:
  - `git_git_status` with untracked files included.
  - `git_git_diff` for the working tree.
  - `git_git_diff` with `staged: true` for the index.
- Treat content already staged at this point as the user's complete commit
  selection. If anything is staged, do not stage additional changes, even if
  session-owned changes remain unstaged. Validate and commit only the existing
  cached payload.
- If the repository is not cleanly attributable to the current session, use
  the session context and tool history to identify the owned files and hunks.
  Do not infer ownership from a filename alone.

### 3. Validate before staging

- Work from the repository root.
- Prefer non-mutating checks and repository-defined commands. Discover the
  available tooling from root configuration and run only commands that are
  configured by the repository.
- JavaScript and TypeScript: inspect `package.json`, workspace configuration,
  and lockfiles. Run configured `lint`, `typecheck`, `test`, `build`, and
  format-check scripts as applicable. Detect pnpm from `pnpm-lock.yaml` or a
  `packageManager` value beginning with `pnpm`; also respect npm, Yarn, and Bun
  markers instead of assuming pnpm.
- Python: inspect `pyproject.toml`, `tox.ini`, `pytest.ini`, and Make targets.
  Run configured lint, type-check, test, and format-check commands.
- Go: when `go.mod` exists, run the repository's configured checks and, when no
  project-specific alternative exists, use `go test ./...` and `go vet ./...`.
- Rust: when `Cargo.toml` exists, run configured checks and, when no
  project-specific alternative exists, use `cargo check` and `cargo test`.
- Other ecosystems: inspect `Makefile`, `justfile`, `Taskfile`, and their
  ecosystem configuration for explicit lint, test, check, or build targets.
- If `.pre-commit-config.yaml` exists, prefer `pre-commit run --files` for the
  attributable files rather than `pre-commit run --all-files`. If content was
  already staged, do not run mutating hooks against the working tree unless
  they can be restricted to a temporary copy or otherwise proven not to alter
  the staged payload. If a hook can modify files, record the pre-validation
  status and diff first, then inspect status and diffs afterward. Do not
  silently include hook-generated changes.
- Classify each check as passed, failed, unavailable, or not configured.
  Missing tooling or an absent check is not an actual failure; report it.
- If a configured check fails, stop and ask whether to fix it or proceed. Never
  silently commit through a failed check.

### 4. Select the commit contents

- If content was already staged during the baseline step, do not run any
  staging operation. Review and commit only that cached payload.
- Otherwise, use current session context, tool history, and the working-tree
  diff to identify exact files and hunks changed during this session. If a
  hunk's ownership is unclear, stop and ask instead of staging it.
- Use `git_git_add` for explicitly identified whole files only when every
  change in each file belongs to this session. Do not stage untracked files
  that were not created or explicitly requested in this session.
- For mixed tracked-file changes, hunk staging may require the shell fallback
  described in **Tool-first Git Operations**. Accept only attributable hunks;
  split mixed hunks and edit patches when necessary. Review the patch before
  applying it.
- Handle new files, deletions, renames, mode changes, binary files, and
  submodules explicitly. If the change cannot be separated safely, stop and
  report the conflict.
- After staging, inspect the exact cached diff with `git_git_diff` using
  `staged: true`, verify the staged file list with `git_git_status`, and run
  `git diff --cached --check` only through the narrowly scoped shell fallback
  because no dedicated Git tool exposes that check. Confirm every staged line
  is attributable to this session.
- If nothing intended is staged, stop and report that there is nothing to
  commit. Do not broaden the selection just to produce a commit.

### 5. Derive the message

- Identify the primary purpose and scope from the cached diff.
- Use the Conventional Commits format:
  `<type>[optional scope][!]: <imperative description>`
- Keep the first line under 72 characters.
- Always include a concise body explaining what changed and why.
- Prefer adding a `Refs: <JIRA-KEY>` footer. Infer Jira keys from the branch
  name first, then from recent commit subjects using `git_git_log`, then from
  the supplied argument or user message. Accept keys matching
  `[A-Z][A-Z0-9_]+-[0-9]+`, including the commonly used `BLD-` and `DEV-`
  projects.
- Jira is optional. If no clear key is available, omit the footer and do not
  block the commit. If several keys clearly apply, add one `Refs:` line per
  key.
- Show the complete proposed commit message and wait for confirmation before
  committing, unless the user explicitly asked to commit and push in the same
  request. The combined "commit and push" request is the user's confirmation
  of the generated commit message; do not ask for a second confirmation.

### 6. Commit

- Use `git_git_commit` rather than invoking `git commit` through the shell. Pass
  the complete subject, body, and optional footer as one message with newline
  escapes. Do not pass `filesToStage` when content was already staged; the
  index is the user's selection. When staging is still required and whole-file
  ownership is unambiguous, stage with `git_git_add` first; use
  `filesToStage` only when its atomic staging behavior is known not to include
  unrelated work.
- The resulting message must have a non-empty body. For example:

  ```text
   fix(auth): prevent token reuse after logout

   Reject reuse of tokens after logout and keep the session state consistent.

   Refs: DEV-103
  ```

- After success, use `git_git_show` to verify the commit hash, message, and
  changed files, then use `git_git_status` to confirm the intended remaining
  work is still present.
- Do not push unless the user explicitly asks for a push. If the user asked to
  commit and push, inspect the resulting commit and remote context with the
  appropriate Git tools, then use `git_git_push` without requesting a second
  confirmation of the commit message.

## Commit Message Rules

Use these types when they match the change:

- `feat`: new functionality
- `fix`: bug fix
- `docs`: documentation only
- `style`: formatting or non-semantic style changes
- `refactor`: behavior-preserving code restructuring
- `perf`: performance improvement
- `test`: tests
- `build`: build system or dependency changes
- `ci`: CI configuration
- `chore`: maintenance
- `revert`: reverting a prior change

Use imperative mood, keep the subject concise, and keep one commit focused on
one purpose. Mark breaking changes with `!` in the header and/or a
`BREAKING CHANGE: <details>` footer.

Examples:

- `feat: add user authentication system`
- `fix: resolve memory leak in rendering process`
- `docs: update API documentation with new endpoints`
- `refactor(parser): simplify nested rule handling`
- `feat(api)!: remove legacy v1 token endpoints`
- `chore(release): cut v2.0.0`

## Failure Conditions

- Never stage or commit unrelated work.
- Never commit an empty body.
- Never conceal validation failures; report them and ask for a decision.
- Never push as an implicit side effect of committing.
