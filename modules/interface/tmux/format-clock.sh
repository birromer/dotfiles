# ~/.tmux/plugins/org-clock/tmux-format.sh
#!/usr/bin/env bash
output=$(~/.tmux/org-clock.sh)
status="${output%%|*}"
msg="${output#*|}"

case "$status" in
  OVER)   echo "#[fg=red,bold]${msg}" ;;
  NONE)   echo "#[fg=red]${msg}" ;;
  *)      echo "#[fg=yellow,bold]${msg}" ;;
esac
