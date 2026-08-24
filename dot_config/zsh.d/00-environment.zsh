export HISTFILE=~/.histfile
export HISTSIZE=65536
export SAVEHIST=9223372036854775807
export EDITOR=nvim
export VISUAL=nvim

setopt INC_APPEND_HISTORY HIST_IGNORE_DUPS EXTENDED_HISTORY
unsetopt autocd extendedglob nomatch
setopt appendhistory notify prompt_subst

if [[ -e "${HOME}/.info" ]]; then
  export TERMINFO="$HOME/.info"
fi

asmrmpv() {
  while sleep 1; do
    mpv -fs "$(find . -mindepth 1 -type f | sort -R | tail -n 1)" \
      --af=lavfi="[dynaudnorm=s=30]"
  done
}

if command -v wslview &>/dev/null; then
  export BROWSER=wslview
fi
