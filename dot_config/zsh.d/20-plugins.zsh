plugins=(
  aliases
  git
  history
  ssh
  ssh-agent
  zsh-navigation-tools
  zsh-autosuggestions
)

zsh_plugin_add() {
  (( ${plugins[(Ie)$1]} )) || plugins+=("$1")
}

zsh_plugin_remove() {
  plugins=(${plugins:#"$1"})
}
