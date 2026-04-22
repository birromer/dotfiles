#!/usr/bin/env bash
# Output format:
#   ACTIVE|⏱ 00:15 / 00:45 / -00:30 Task name
#   OVER|⏱ 00:05 / 01:45 / -00:00 Task name
#   NONE|No clock running

ORG_DIR="$HOME/cloud/org"

effort_to_minutes() {
  local eff="$1"
  local total=0
  if [[ "$eff" =~ ^([0-9]+):([0-9]+)$ ]]; then
    echo $(( ${BASH_REMATCH[1]} * 60 + ${BASH_REMATCH[2]} )); return
  fi
  if [[ "$eff" =~ ^([0-9]+)d$ ]]; then
    echo $(( ${BASH_REMATCH[1]} * 8 * 60 )); return
  fi
  if [[ "$eff" =~ ^([0-9]+)w$ ]]; then
    echo $(( ${BASH_REMATCH[1]} * 5 * 8 * 60 )); return
  fi
  if [[ "$eff" =~ ([0-9]+)h ]]; then
    total=$(( total + ${BASH_REMATCH[1]} * 60 ))
  fi
  if [[ "$eff" =~ ([0-9]+)m ]]; then
    total=$(( total + ${BASH_REMATCH[1]} ))
  fi
  [ "$total" -gt 0 ] && echo "$total"
}

fmt_duration() {
  local mins=$1
  local h=$((mins / 60))
  local m=$((mins % 60))
  printf "%02d:%02d" "$h" "$m"
}

for f in "$ORG_DIR"/*.org; do
  [ -f "$f" ] || continue
  clock_line=$(grep -nE '^[[:space:]]*CLOCK: \[[0-9]{4}-[0-9]{2}-[0-9]{2} [A-Za-z]+ [0-9]{2}:[0-9]{2}\][[:space:]]*$' "$f" | head -1)
  [ -z "$clock_line" ] && continue

  line_num=$(echo "$clock_line" | cut -d: -f1)
  date_part=$(echo "$clock_line" | sed -nE 's/.*\[([0-9]{4}-[0-9]{2}-[0-9]{2}) [A-Za-z]+ ([0-9]{2}:[0-9]{2})\].*/\1 \2/p')

  session_min=0
  if [ -n "$date_part" ]; then
    start_epoch=$(date -j -f "%Y-%m-%d %H:%M" "$date_part" "+%s" 2>/dev/null)
    now_epoch=$(date "+%s")
    session_min=$(( (now_epoch - start_epoch) / 60 ))
  fi

  headline_line=$(sed -n "1,${line_num}p" "$f" | grep -nE '^\*+ ' | tail -1 | cut -d: -f1)
  headline=$(sed -n "${headline_line}p" "$f")
  [ -z "$headline" ] && continue

  stars=$(echo "$headline" | grep -oE '^\*+')
  level=${#stars}
  total_lines=$(wc -l < "$f")
  subtree_end=$total_lines
  for (( i=headline_line+1; i<=total_lines; i++ )); do
    line=$(sed -n "${i}p" "$f")
    if [[ "$line" =~ ^(\*+)\  ]]; then
      other_stars="${BASH_REMATCH[1]}"
      if [ ${#other_stars} -le $level ]; then
        subtree_end=$((i - 1))
        break
      fi
    fi
  done

  total_clocked=0
  while IFS= read -r l; do
    if [[ "$l" =~ \=\>[[:space:]]+([0-9]+):([0-9]+) ]]; then
      total_clocked=$(( total_clocked + ${BASH_REMATCH[1]} * 60 + ${BASH_REMATCH[2]} ))
    fi
  done < <(sed -n "${headline_line},${subtree_end}p" "$f")
  total_clocked=$(( total_clocked + session_min ))

  effort_str=$(sed -n "${headline_line},${subtree_end}p" "$f" \
    | grep -m1 -E ':Effort:[[:space:]]+' \
    | sed -E 's/.*:Effort:[[:space:]]+([^[:space:]].*[^[:space:]]|[^[:space:]])[[:space:]]*$/\1/')

  title=$(echo "$headline" \
    | sed -E 's/^\*+[[:space:]]+//' \
    | sed -E 's/^(TODO|NEXT|WAIT|LATER|DONE|CANCELLED)[[:space:]]+//' \
    | sed -E 's/\[#[A-Z]\][[:space:]]*//' \
    | sed -E 's/[[:space:]]+:[a-zA-Z_:]+:[[:space:]]*$//')
  [ ${#title} -gt 40 ] && title="${title:0:37}..."

  session_str=$(fmt_duration $session_min)
  total_str=$(fmt_duration $total_clocked)

  status="ACTIVE"
  if [ -n "$effort_str" ]; then
    effort_min=$(effort_to_minutes "$effort_str")
    if [ -n "$effort_min" ] && [ "$effort_min" -gt 0 ]; then
      remaining=$(( effort_min - total_clocked ))
      if [ "$remaining" -le 0 ]; then
        remaining=0
        status="OVER"
      fi
      remaining_str=$(fmt_duration $remaining)
      echo "${status}| ⏱ ${title} | + ${session_str} | ~ ${total_str} | - ${remaining_str}"
      exit 0
    fi
  fi

  echo "ACTIVE|⏱ ${title} | + ${session_str} | ~ ${total_str} "
  exit 0
done

# No clock found
echo "NONE|⚠ no clock running"
