#!/usr/bin/env zsh


set -e

SVOL='/Volumes/My Shared Files'
if [ ! -e "$SVOL" ]; then
    echo "** ERROR: Cannot find shared volume - make sure you used --vol /Volumes/VM/shared,automount or similar."
    exit 1
fi


mkdir -p ~/.config/chezmoi
cat << 'EOF' > ~/.config/chezmoi/chezmoi.toml
[env]
GH_SKIP = "1"
EOF
zsh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init -R=always --use-builtin-git true --apply https://github.com/raypappa/chezmoi-dotfiles.git

echo "Finished installing dotfiles"

cd "$SVOL"
./tests.sh
