---
description: Create well-formatted commits with conventional commit messages
---

# Commit Command

You are an AI agent that helps create well-formatted git commits with conventional commit messages, follow these instructions exactly. Always run and push the commit, you don't need to ask for confirmation unless there is a big issue or error.

## Instructions for Agent

When the user runs this command, execute the following workflow:

1. **Check command mode**:

   - If user provides $ARGUMENTS (a simple message), skip to step 3

1. **Run pre-commit validation**:

   - If `.pre-commit-config.yaml` exists at repo root, execute `pre-commit run --all-files` first
   - Run `pnpm` checks only when pnpm markers are present (for example: `pnpm-lock.yaml`, or `package.json` with `"packageManager": "pnpm..."`)
   - If pnpm markers are present, execute `pnpm lint` and report any issues
   - If pnpm markers are present, execute `pnpm build` and ensure it succeeds
   - If pnpm markers are not present, skip pnpm validation steps
   - If any validation step fails, ask user if they want to proceed anyway or fix issues first

1. **Analyze git status**:

   - Run `git status --porcelain` to check for changes
   - If no files are staged, run `git add -u` to stage all modified files
   - If files are already staged, proceed with only those files

1. **Analyze the changes**:

   - Run `git diff --cached` to see what will be committed
   - Analyze the diff to determine the primary change type (feat, fix, docs, etc.)
   - Identify the main scope and purpose of the changes

1. **Generate commit message**:

   - Choose an appropriate commit type from the reference below
   - Create message following Conventional Commits format: `<type>[optional scope][!]: <description>`
   - Always include a concise body describing what changed and why; add a footer when needed
   - Add a Jira footer in this format: `Refs: <JIRA-KEY>`
   - Infer Jira key from branch name first, then from `$ARGUMENTS` if present
   - If no Jira key is found, stop immediately and ask the user for a valid jira issue id.
   - Keep description concise, clear, and in imperative mood
   - Show the proposed message to user for confirmation

1. **Execute the commit**:

   - Always use multiple `-m` flags so every commit has a non-empty body (for example: `git commit -m "<header>" -m "<body>" -m "<footer>"`)
   - Display the commit hash and confirm success
   - Provide brief summary of what was committed

## Commit Message Guidelines

When generating commit messages, follow these rules:

- **Atomic commits**: Each commit should contain related changes that serve a single purpose
- **Imperative mood**: Write as commands (e.g., "add feature" not "added feature")
- **Concise first line**: Keep under 72 characters
- **Conventional format**:
  - Header: `<type>[optional scope][!]: <description>`
  - Body (required): explain what changed and why after a blank line
  - Footer (optional): use standard trailers, especially `BREAKING CHANGE: <details>`
  - `!` in the header indicates a breaking change
- **Required core types**:
  - `feat`: A new feature
  - `fix`: A bug fix
- **Common additional types**:
  - `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`
- **Present tense, imperative mood**: Write commit messages as commands (e.g., "add feature" not "added feature")
- **Concise first line**: Keep the first line under 72 characters
- **Breaking changes**:
  - Indicate with `!` and/or `BREAKING CHANGE:` footer
  - Example: `feat(api)!: remove v1 authentication endpoint`
- **Jira linkage footer**:
  - Add `Refs: BLD-123` or `Refs: DEV-123` as a footer line
  - If multiple stories apply, add one `Refs:` line per story
  - If no Jira key is available, do not create or push a commit

## Reference: Good Commit Examples

Use these as examples when generating commit messages:

- feat: add user authentication system
- fix: resolve memory leak in rendering process
- docs: update API documentation with new endpoints
- refactor: simplify error handling logic in parser
- fix: resolve linter warnings in component files
- chore: improve developer tooling setup process
- feat: implement business logic for transaction validation
- fix: address minor styling inconsistency in header
- fix: patch critical security vulnerability in auth flow
- style: reorganize component structure for better readability
- fix: remove deprecated legacy code
- feat: add input validation for user registration form
- fix: resolve failing CI pipeline tests
- feat: implement analytics tracking for user engagement
- fix: strengthen authentication password requirements
- feat: improve form accessibility for screen readers
- feat(parser): support nested rule groups in commit parser
- fix(ui): prevent duplicate submit on slow networks
- refactor(core): split validation pipeline into modules
- feat(api)!: remove legacy v1 token endpoints
- chore(release): cut v2.0.0

Example commit sequence:

- feat: add user authentication system
- fix: resolve memory leak in rendering process
- docs: update API documentation with new endpoints
- refactor: simplify error handling logic in parser
- fix: resolve linter warnings in component files
- test: add unit tests for authentication flow

Example with body/footer:

`feat(api)!: replace legacy session token format`

`BREAKING CHANGE: session tokens issued before 2026-06-01 are no longer valid.`

`Refs: DEV-642`

Example with Jira footer only:

`fix(auth): prevent token reuse after logout`

`Refs: BLD-103`

## Agent Behavior Notes

- **Error handling**: If validation fails, give user option to proceed or fix issues first
- **Pre-commit support**: If `.pre-commit-config.yaml` exists, run `pre-commit run --all-files` during validation, except in `ubq/deploy` where pre-commit is always skipped
- **pnpm detection**: Only run `pnpm lint` / `pnpm build` when pnpm markers exist in the repo
- **Auto-staging**: If no files are staged, automatically stage all changes with `git add .`
- **File priority**: If files are already staged, only commit those specific files
- **Jira footer default**: Include a `Refs:` footer using `BLD-` or `DEV-` issue keys when available
- **Jira key required**: If no valid `BLD-` or `DEV-` key is found, stop and request one before committing
- **Message quality**: Ensure commit messages are clear, concise, and follow conventional format
- **Success feedback**: After successful commit, show commit hash and brief summary
