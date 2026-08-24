if [[ -x /usr/local/bin/aws_completer ]]; then
  autoload -Uz bashcompinit
  bashcompinit
  complete -C '/usr/local/bin/aws_completer' aws
fi

if command -v mise &>/dev/null; then
  eval "$(mise completion zsh)"
fi
if command -v jira &>/dev/null; then
  eval "$(jira completion zsh)"
fi
if command -v fjira &>/dev/null; then
  eval "$(fjira completion zsh)"
fi
if command -v chezmoi &>/dev/null; then
  eval "$(chezmoi completion zsh)"
fi
if command -v glab &>/dev/null; then
  source <(glab completion -s zsh)
  compdef _glab glab
fi
if command -v op &>/dev/null; then
  source <(op completion zsh)
  compdef _op op
fi
if command -v helm &>/dev/null; then
  source <(helm completion zsh)
fi
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi
if command -v rdctl &>/dev/null; then
  source <(rdctl completion zsh)
fi
if command -v ruff &>/dev/null; then
  source <(ruff generate-shell-completion zsh)
fi
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi
if command -v rg &>/dev/null; then
  source <(rg --generate=complete-zsh)
fi
if command -v tree-sitter &>/dev/null; then
  source <(tree-sitter complete -s zsh)
fi
if command -v task &>/dev/null; then
  source <(task --completion zsh)
fi
if command -v ytt &>/dev/null; then
  source <(ytt completion zsh)
fi
if command -v conform &>/dev/null; then
  source <(conform completion zsh)
fi
if command -v yq &>/dev/null; then
  source <(yq completion zsh)
fi
if command -v kustomize &>/dev/null; then
  source <(kustomize completion zsh)
fi
if command -v argo-cd &>/dev/null; then
  source <(argo-cd completion zsh)
fi
if command -v trivy &>/dev/null; then
  source <(trivy completion zsh)
fi
if command -v dive &>/dev/null; then
  source <(dive completion zsh)
fi
if command -v taplo &>/dev/null; then
  source <(taplo completions zsh)
fi
if command -v k9s &>/dev/null; then
  source <($(whence -p k9s) completion zsh)
fi

if mise where gcloud &>/dev/null; then
  gcloud_completion="$(mise where gcloud)/completion.zsh.inc"
  if [[ -r "$gcloud_completion" ]]; then
    source "$gcloud_completion"
  fi
  unset gcloud_completion
fi

if [[ -r "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc" ]]; then
  source "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"
fi
