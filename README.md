# dotfiles

Revamped dotfiles now with chezmoi.

Currently I'm using tmux, bash, and neovim for tooling workflows. Other
items may not be very well maintained

**NOTE: Don't forget to copy the alacritty.toml file to windows to %APPDATA%\\alacritty\\alacritty.toml**

## Bootstrap on Windows

1. Open a User Powershell terminal

1. Install Packages

   ```powershell
   winget install -h --accept-package-agreements -e Alacritty.Alacritty 7zip.7zip Amazon.AWSCLI Audacity.Audacity CodecGuide.K-LiteCodecPack.Standard Chocolatey.Chocolatey Mozilla.Firefox  AgileBits.1Password AgileBits.1Password.CLI Git.Git Greenshot.Greenshot Task.Task OliverSchwendener.ueli Amazon.NoSQLWorkbench suse.RancherDesktop SlackTechnologies.Slack VideoLAN.VLC Microsoft.VisualStudioCode Microsoft.VisualStudioCode.CLI Yubico.Piv-Tool Yubico.YubikeyManager Yubico.YubiKeyManagerCLI Yubico.YubiKeyPersonalizationTool Microsoft.PowerShell Microsoft.WindowsTerminal  Atlassian.Sourcetree Joplin.Joplin Zoom.Zoom OpenJS.NodeJS jqlang.jq
   winget install -h --accept-package-agreements sysinternals
   ```

1. Close the User Powershell terminal and open an Admin Powershell terminal

1. Install the chocolatey based packages(mostly nerd fonts)

   ```powershell
   choco upgrade -y nerd-fonts-FiraMono chocolatey chocolatey-compatibility.extension chocolatey-core.extension chocolatey-dotnetfx.extension chocolatey-windowsupdate.extension  openhardwaremonitor
   ```

1. Close the Admin Powershell and open a fresh user terminal.

1. Update terminal settings

   1. Open a new powershell window

   1. If using alacritty do the following

      ```powershell
      $dir="$env:APPDATA\alacritty";
      New-Item -Path "$dir" -Type Directory;
      foreach ($file in  @("alacritty.toml", "key-bindings.toml", "scheme.toml")) {
      (New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/raypappa/chezmoi-dotfiles/refs/heads/main/dot_config/alacritty/$file") | Out-File -NoNewline -Encoding utf8 -FilePath "$dir\$file";
      }
      (New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/raypappa/chezmoi-dotfiles/refs/heads/main/dot_config/alacritty/executable_windows.toml") | Out-File -NoNewline -Encoding utf8 -FilePath "$dir\windows.toml";
      ```

   1. If using Windows Terminal do the following

      ```powershell
      $termSettingsConfig="$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
      $termSettings = Get-Content $termSettingsConfig -raw | ConvertFrom-Json
      $termSettings.profiles.defaults.colorScheme = "Solarized Dark"
      $termSettings.profiles.defaults.font.face = "FiraMono Nerd Font"
      $termSettings.keybindings = ($termSettings.keybindings | ? {$_.keys -ne "ctrl+c"})
      $termSettings | ConvertTo-Json -depth 32| set-content $termSettingsConfig
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
wsl.exe --update
```

## Pre-requisites

1. On MacOS only: Install homebrew

   ```shell
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

## Install

1. Install chezmoi

```shell
sudo -v
sudo apt install curl -y
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin init -R=always --use-builtin-git true --apply https://github.com/raypappa/chezmoi-dotfiles.git
chsh -s $(which zsh)
```

### tmux

started having issues with tmux. might need to override `TERM=xterm-256color` instead of `alacritty`
stead of powershell by default

### Testing config

Must have docker present

```shell
docker run -it --rm debian sh -c 'apt update && apt install sudo && adduser --comment "" --disabled-password debian && usermod -a -G sudo debian && echo 'debian:foobar' | chpasswd && sudo -u debian -i'
```

Then run the install instructions from the previous section
