# Shared helpers: paths listed in .skeleton/.syncignore are not copied to the consumer root
# by init-skeleton.sh or sync-skeleton.sh.

syncignore_file() {
  local root="$1"
  if [[ -f "$root/.skeleton/.syncignore" ]]; then
    echo "$root/.skeleton/.syncignore"
  fi
}

is_syncignored() {
  local root="$1"
  local rel="$2"
  local sf line
  sf="$(syncignore_file "$root")"
  [[ -n "${sf:-}" ]] || return 1
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ -z "$line" || "$line" == \#* ]] && continue
    [[ "$line" == "$rel" ]] && return 0
  done <"$sf"
  return 1
}
