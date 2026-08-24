if aws_completer_path=$(whence -p aws_completer 2>/dev/null); then
  autoload -Uz bashcompinit
  bashcompinit
  complete -C "$aws_completer_path" aws
  unset aws_completer_path
fi

if command -v chezmoi &>/dev/null; then
  eval "$(chezmoi completion zsh)"
fi
if command -v rdctl &>/dev/null; then
  source <(rdctl completion zsh)
fi

if [[ -r "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc" ]]; then
  source "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"
fi
