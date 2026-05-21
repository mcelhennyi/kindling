#!/usr/bin/env bash
# Shared helper: paths in .kindling/.syncignore are not copied to the consumer root
# by init-kindling.sh or sync-kindling.sh.

kindling_syncignore_file() {
  local root="$1"
  if [[ -f "$root/.kindling/.syncignore" ]]; then
    echo "$root/.kindling/.syncignore"
  fi
}

is_kindling_syncignored() {
  local root="$1"
  local rel="$2"
  local sf line
  sf="$(kindling_syncignore_file "$root")"
  [[ -n "${sf:-}" ]] || return 1
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ -z "$line" || "$line" == \#* ]] && continue
    [[ "$line" == "$rel" ]] && return 0
  done <"$sf"
  return 1
}
