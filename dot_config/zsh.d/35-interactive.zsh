fpath=("$HOME/.local/share/zsh/completions" $fpath)

if [[ -o interactive && -o zle ]]; then
  bindkey "^[[1;5C" forward-word
  bindkey "^[[1;5D" backward-word
fi
