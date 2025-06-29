# dotfiles

Revamped dotfiles now with chezmoi.

Currently I'm using tmux, bash, and neovim for tooling workflows. Other
items may not be very well maintained

**NOTE: Don't forget to copy the alacritty.toml file to windows to %APPDATA%\alacritty\alacritty.toml**

## Bootstrap on Windows

1. Open a User Powershell terminal
1. Install Packages

    ```powershell
    winget install -h --accept-package-agreements -e Alacritty.Alacritty 7zip.7zip Amazon.AWSCLI Audacity.Audacity CodecGuide.K-LiteCodecPack.Standard Chocolatey.Chocolatey Mozilla.Firefox  AgileBits.1Password AgileBits.1Password.CLI Git.Git Greenshot.Greenshot Task.Task OliverSchwendener.ueli Amazon.NoSQLWorkbench suse.RancherDesktop SlackTechnologies.Slack VideoLAN.VLC Microsoft.VisualStudioCode Microsoft.VisualStudioCode.CLI Yubico.Piv-Tool Yubico.YubikeyManager Yubico.YubiKeyManagerCLI Yubico.YubiKeyPersonalizationTool Microsoft.PowerShell Microsoft.WindowsTerminal  Atlassian.Sourcetree Joplin.Joplin Zoom.Zoom OpenJS.NodeJS
    winget install -h --accept-package-agreements sysinternals
    ```

1. Close the User Powershell terminal and open an Admin Powershell terminal

1. Install the chocolatey based packages(mostly nerd fonts)

   ```powershell
   choco upgrade -y nerd-fonts-FiraMono chocolatey chocolatey-compatibility.extension chocolatey-core.extension chocolatey-dotnetfx.extension chocolatey-windowsupdate.extension  openhardwaremonitor
   ```

1. Close the Admin Powershell and open a fresh user terminal.

1. In a new User Powershell download the Alacritty Toml

    ```powershell
    $dst="$env:APPDATA\alacritty\alacritty.toml";
    $dir=(Split-Path -Parent $dst);
    New-Item -Path "$dir" -Type Directory;
    (New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/blade2005/dotfiles/main/.config/alacritty.toml") | Out-File -NoNewline -Encoding utf8 -FilePath "$dst";
    (New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/blade2005/dotfiles/main/.config/alacritty.win.toml") | Out-File -NoNewline -Encoding utf8 -Append -FilePath "$dst";
    ```

1. Configure Rancher

   ```powershell
   rdctl list-settings
   rdctl
   ```

### WSL

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

powercfg.exe /hibernate off

wsl.exe --set-default-version 2
wsl.exe --install -d Debian
```

## Pre-requisites

1. On MacOS only: Install homebrew

    ```shell
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

1. Install uv

    ```shell
    UV_UNMANAGED_INSTALL=1 UV_NO_MODIFY_PATH=1 curl -LsSf https://astral.sh/uv/install.sh | sh
    ```

## Install

1. Execute ansible with uv

    ```shell
    sudo -v
    ```

1. Install chezmoi

```shell
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/raypappa/chezmoi-dotfiles.git
```

### tmux

started having issues with tmux. might need to override `TERM=xterm-256color` instead of `alacritty`
stead of powershell by default
