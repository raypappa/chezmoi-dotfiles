#!/usr/bin/env zsh


set -e

SVOL='/Volumes/My Shared Files'
if [ ! -e "$SVOL" ]; then
    echo "** ERROR: Cannot find shared volume - make sure you used --vol /Volumes/VM/shared,automount or similar."
    exit 1
fi


export GH_SKIP=1
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin init -R=always --use-builtin-git true --apply https://github.com/raypappa/chezmoi-dotfiles.git

echo "Finished installing dotfiles"

cd "$SVOL"
./tests.sh
