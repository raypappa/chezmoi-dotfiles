add2path() {
  local path_entry=$1
  local existing_index=$path[(Ie)$path_entry]
  if (( existing_index )); then
    path[$existing_index]=()
  fi
  if [[ $2 == "front" ]]; then
    path=($path_entry $path)
  else
    path+=($path_entry)
  fi
  export PATH
}

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  add2path "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/opt/gnu-indent/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/opt/gnu-time/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/opt/gnu-which/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/opt/gpatch/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/opt/make/libexec/gnubin" "front"
  add2path "$HOMEBREW_PREFIX/Caskroom/gcloud-cli/latest/google-cloud-sdk/bin"
fi

if [[ -d "${HOME}/Library/Python" ]]; then
  for path_entry in "${HOME}/Library/Python"/*/bin(N-/); do
    add2path "$path_entry" "front"
  done
fi

add2path "$HOME/.local/bin" "front"
add2path "$HOME/.krew/bin" "front"
add2path "$HOME/.git-plugins/bin" "front"
add2path "$HOME/.git-extras/bin" "front"
add2path "$HOME/.rd/bin" "front"
add2path "${KREW_ROOT:-$HOME/.krew}/bin"

if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi
