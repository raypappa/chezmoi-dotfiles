function alert() {
  local exit_code=$?
  local cmd=$(history | tail -n1 | sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')
  local title=$([ $exit_code = 0 ] && echo "Done" || echo "Failed")

  if command -v notify-send &>/dev/null; then
    notify-send --urgency=low "$title" "$cmd"
  elif command -v terminal-notifier &>/dev/null; then
    terminal-notifier -title "$title" -message "$cmd"
  else
    print -u2 "alert: no notifier found (install notify-send or terminal-notifier)"
    return 1
  fi
}

function start-rdp {
  ssm-port "$1" 3389 3389
}

function ssm-port {
  local target=$1 localport=$2 remoteport=$3
  aws ssm start-session --target "$target" \
    --document-name AWS-StartPortForwardingSession \
    --parameters '''{"portNumber":["'$remoteport'"],"localPortNumber":["'$localport'"]}'''
}

function start-session {
  aws ssm start-session --target "$1"
}

function ssm {
  aws ssm start-session --target "$2" --profile "$1" --region us-east-1
}

fix_wsl2_interop() {
  for process_id in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
    if [[ -e "/run/WSL/${process_id}_interop" ]]; then
      export WSL_INTEROP="/run/WSL/${process_id}_interop"
    fi
  done
}

function e() {
  local file=$(notes list -s category | gum choose)
  if [[ ! -e "$file" ]]; then
    print -u2 "Missing file"
    return 1
  fi
  vim "$file"
}
