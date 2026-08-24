# AGENTS.md

## Repository purpose and scope

Chezmoi-managed dotfiles. Source files use chezmoi naming (`dot_*`, `run_*`, `*.tmpl`); they are **not** target paths. Edit source names, not `~/.config/...` paths.

Managed areas: shell (`dot_zshrc`, `dot_bashrc`, `dot_zaliases`, `dot_zshenv`), terminal/tmux (`dot_tmux.conf`, `dot_config/alacritty/`), Neovim (`dot_config/nvim/`), X11, fluxbox, i3, starship (`dot_config/starship.toml`), mise (`dot_config/mise/`), and install scripts (`run_*`).

## Chezmoi conventions

- `dot_*` → target dotfile. `dot_config/foo` → `~/.config/foo`.
- `run_before_*` / `run_after_*` → lifecycle hooks run by `chezmoi apply`.
- `*.tmpl` → rendered via Go templates. Template guards use `{{ if eq .chezmoi.os "darwin" "linux" }}`.
- `.chezmoidata/packages.yaml` — single source of truth for package lists; structure is `packages.darwin.{brews,casks,taps}` and `packages.linux.debian`.
- `.chezmoiexternal.toml` — manages 5 external git repos/archives (oh-my-zsh, git-plugins, git-extras, zsh-autosuggestions, OpenDyslexic font). All `refreshPeriod = "168h"`.
- `.chezmoiignore` — excludes `README.md`, `AGENTS.md`, `tags*`, and `tests/` from target application.

## Bootstrap / install flow

**Linux/macOS initial install:**
```sh
sudo -v
sudo apt install curl -y   # Linux only
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin init -R=always --use-builtin-git true --apply https://github.com/raypappa/chezmoi-dotfiles.git
chsh -s $(which zsh)
```

**Hook execution order on `chezmoi apply`:**
1. `run_before_once_install_mise.sh.tmpl` — installs mise via `curl https://mise.run | sh` if not found (darwin + linux only).
2. `run_before_onchange_install-packages.sh.tmpl` — installs brew/apt packages from `packages.yaml`; also installs starship via `curl | sh` on Linux and runs `defaults write com.abhishek.Clocker startAtLogin 1` on Darwin.
3. `run_after_once_setup_mise.sh.tmpl` — installs `gh`, `uv`, `aqua`, `ubi`, and all tools in mise config. `GH_SKIP=1` (or `[env] GH_SKIP = "1"` in `chezmoi.toml`) suppresses the GitHub auth steps — used in VM builds.

Hook scripts use `#!/bin/bash` or `#!/bin/sh` shebangs, not zsh.

## macOS VM test flow

All scripts live in `tests/macos/`. The directory also contains committed disk images (`disk.img`, `aux.img`, `master.img`) and an IPSW (`UniversalMac_26.4_25E246_Restore.ipsw`).

**1. Provision (one-time):** `tests/macos/provision.sh`
- Finds `*.ipsw` via `find . | gum choose --select-if-one`.
- Restores image, launches interactive GUI VM (`macosvm -g vm.json`) for manual macOS setup (user creation, remote login, SSH keys, brew install, sudoers), then clones disk to `master.img`.
- This is a manual process requiring interactive steps between restore and clone.

**2. Interactive login:** `tests/macos/run.sh [-p]`
- `-p` disables ephemeral mode (default is ephemeral).
- Mounts `$(pwd)/shared` as the shared volume and passes `--script ./launch.sh`.
- `launch.sh` waits for VM IP via ARP (up to 40s) and **prints** the SSH command — user must run it manually.
- Requires `MACOSVM` env var, `macosvm` in `PATH`, or `./macosvm`.

**3. Build test:** `tests/macos/run-build.sh`
- Same as `run.sh` but passes `--script ./launch-build.sh`.
- `launch-build.sh` auto-SSHes and runs `/Volumes/My\ Shared\ Files/run-arm64.sh build.sh` inside the VM.

**4. VM-side build:** `tests/macos/shared/build.sh`
- Writes `GH_SKIP = "1"` into `~/.config/chezmoi/chezmoi.toml` before bootstrapping.
- Uses `get.chezmoi.io/lb` (latest binary URL, different from README's `get.chezmoi.io`).
- Runs `tests/macos/shared/tests.sh` via `zsh -l` from the shared volume.

**5. Validation:** `tests/macos/shared/tests.sh`
- `set -e -x`; strict `whence -p` equality checks for GNU tools (sed, make, patch, time, tar, awk, find, date, base64, dd, tee, tr) against `/opt/homebrew/.../gnubin/` paths, then `mise doctor`, `brew doctor`.
- Intentionally brittle — failures mean GNU tools are not winning `PATH` priority.

SSH relaxed host-key behavior (`StrictHostKeyChecking=accept-new`, `UserKnownHostsFile=/dev/null`) is in `launch.sh` / `launch-build.sh`.

## Neovim architecture

Entrypoint: `dot_config/nvim/init.lua`. Load order: `options` → `keymaps` → `lazy-bootstrap` → `lazy-plugins`.

- Kickstart base plugins: `lua/kickstart/plugins/` (15 files, including lspconfig, telescope, treesitter, conform, mini, neo-tree, etc.)
- Custom plugins: `lua/custom/plugins/` (17 files, including `github-copilot.lua`, `codecompanion.lua`, `chezmoi.lua`, `lazygit.lua`, `tmux.lua`, `yaml-companion.lua`, etc.)
- Active LSP servers (in `local servers = {}`): only `terraformls`, `rust_analyzer`, `lua_ls`. Other servers (gopls, pyright, clangd) are commented out but still in Mason's `ensure_installed`.
- Neovim config is a modified kickstart-modular fork; upstream docs may not match.

## Shell conventions

- `dot_zshrc` uses Oh My Zsh with theme `robbyrussell` and starship initialized after (`eval "$(starship init zsh)"` if starship is in PATH). `CASE_SENSITIVE="true"`.
- The managed Oh My Zsh plugins are `aliases`, `git`, `history`, `ssh`,
  `ssh-agent`, `zsh-navigation-tools`, and `zsh-autosuggestions`.
- History is heavily configured: `SAVEHIST=1000000`, dedup + share across sessions.
- `dot_zshrc` loads interactive modules from `~/.config/zsh.d/` and the local
  `~/.dotfiles/.config/zsh.d/` directory in lexical order.
- `dot_tmux.conf`: prefix is `C-a`; includes vim↔tmux navigation interop with process-detection passthrough.

## Pre-commit

`.pre-commit-config.yaml` (rev `v4.6.0`): `trailing-whitespace`, `end-of-file-fixer`, `check-yaml`, `check-added-large-files`.

## Safe change strategy

1. Modify source-state files (`dot_*`, `dot_config/*`) — never the imagined target paths.
2. For package changes: update `.chezmoidata/packages.yaml`; the install hook templates read from it.
3. For Neovim plugins: trace `init.lua` → `lazy-plugins.lua` → specific plugin file.
4. For macOS test changes: keep `launch-build.sh` (host) and `shared/build.sh` + `shared/tests.sh` (guest) aligned. The `GH_SKIP` variable must flow from `shared/build.sh` → chezmoi.toml → `run_after_once_setup_mise.sh.tmpl`.
5. Hook scripts intentionally use `curl | sh` installers (mise, starship, chezmoi lb); preserve OS/template guards when modifying.
6. No Makefile, CI workflows, or package.json at repo root. No OpenCode config (no `opencode.json`, no `.opencode/`).
