---
name: commit
description: Use when the user asks to create a git commit, commit changes, or prepare a Conventional Commit from the current worktree. Validate the repository, stage only the intended changes, require a Jira reference, propose the message for confirmation, and commit with a non-empty body.
version: 1.0.0
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
work. I inspect what is actually staged, keep the commit atomic, and stop when
the repository or the message has an unresolved ambiguity. I commit only after
the user confirms the proposed message. I never push automatically; pushing is
a separate operation that requires an explicit user request.

## Workflow

Follow this sequence whenever the skill is invoked.

### 1. Interpret input

- Treat a supplied argument as a requested message hint, not as permission to
  skip safety checks or message confirmation.
- If the user supplied a simple message, use it to guide the generated subject
  and scope, then still inspect the diff and add the required body and Jira
  footer.

### 2. Validate before staging

- Work from the repository root.
- If `.pre-commit-config.yaml` exists, run `pre-commit run --all-files` first,
  except in `ubq/deploy`, where pre-commit is skipped.
- Detect pnpm using repository markers such as `pnpm-lock.yaml` or a
  `package.json` whose `packageManager` starts with `pnpm`.
- When pnpm markers exist, run `pnpm lint` and `pnpm build`.
- When pnpm markers do not exist, skip both pnpm checks.
- If any validation fails, stop and ask whether to fix the issue or proceed
  anyway. Do not silently commit through failed validation.

### 3. Select the commit contents

- Run `git status --porcelain`.
- If nothing is staged, stage modified and deleted tracked files with
  `git add -u`. Do not stage untracked files automatically.
- If anything is already staged, preserve the user's selection and do not add
  unrelated files.
- If there is still nothing staged, stop and report that there is nothing to
  commit.
- Inspect the exact commit payload with `git diff --cached`.

### 4. Derive the message

- Identify the primary purpose and scope from the cached diff.
- Use the Conventional Commits format:
  `<type>[optional scope][!]: <imperative description>`
- Keep the first line under 72 characters.
- Always include a concise body explaining what changed and why.
- Add a `Refs: <JIRA-KEY>` footer. Infer Jira keys from the branch name first,
  then from the supplied argument or user message. Accept keys matching
  `[A-Z][A-Z0-9_]+-[0-9]+`, including the commonly used `BLD-` and `DEV-`
  projects.
- If no valid Jira key is available, stop and ask the user for one. Do not
  create a commit without the Jira footer.
- If multiple Jira keys clearly apply, add one `Refs:` line per key.
- Show the complete proposed commit message and wait for confirmation before
  committing.

### 5. Commit

- Use multiple `-m` flags so the body is non-empty. Include the footer as a
  separate message when present, for example:

  ```sh
  git commit -m "fix(auth): prevent token reuse after logout" \
    -m "Reject reuse of tokens after logout and keep the session state consistent." \
    -m "Refs: DEV-103"
  ```

- After success, display the commit hash and briefly summarize the committed
  changes.
- Do not push unless the user explicitly asks for a push. If asked to push,
  inspect the resulting commit and remote context, then use the repository's
  normal git push workflow.

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
- Never commit without a valid Jira reference.
- Never conceal validation failures; report them and ask for a decision.
- Never push as an implicit side effect of committing.
