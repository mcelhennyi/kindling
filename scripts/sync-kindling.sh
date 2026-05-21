#!/usr/bin/env bash
# Sync both template layers in a Kindling plugin repo.
#
# Step 1: update .skeleton/ submodule + re-apply skeleton manifest
# Step 2: update .kindling/ submodule + re-apply kindling manifest
#
# Run from the plugin repo root.  After sync, read both changelogs:
#   .skeleton/CHANGELOG.md   (follow Consumer manual: bullets)
#   .kindling/CHANGELOG.md   (follow Consumer manual: bullets)
set -euo pipefail

die() { echo "sync-kindling: $*" >&2; exit 1; }

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || die "not inside a git repository"
}

list_manifest_pairs() {
  local mf="$1"
  [[ -f "$mf" ]] || die "missing manifest: $mf"
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    [[ "$line" == *"|"* ]] || die "manifest line missing | : $line"
    echo "$line"
  done <"$mf"
}

# shellcheck source=kindling-ignore.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kindling-ignore.sh"

main() {
  local root
  root="$(repo_root)"
  cd "$root"

  # -----------------------------------------------------------------------
  # Step 1: sync skeleton layer
  # -----------------------------------------------------------------------
  echo "sync-kindling: Step 1 — syncing skeleton layer ..."
  [[ -f .gitmodules ]] && grep -qF '[submodule ".skeleton"]' .gitmodules 2>/dev/null \
    || die ".skeleton/ submodule not registered (run init-kindling first)"
  [[ -d .skeleton/.git || -f .skeleton/.git ]] \
    || die ".skeleton is not initialized (run: git submodule update --init .skeleton)"
  bash .skeleton/scripts/sync-skeleton.sh

  # -----------------------------------------------------------------------
  # Step 2: sync kindling layer
  # -----------------------------------------------------------------------
  echo "sync-kindling: Step 2 — syncing kindling layer ..."
  [[ -f .gitmodules ]] && grep -qF '[submodule ".kindling"]' .gitmodules 2>/dev/null \
    || die ".kindling/ submodule not registered (run init-kindling first)"
  [[ -d .kindling/.git || -f .kindling/.git ]] \
    || die ".kindling is not initialized (run: git submodule update --init .kindling)"

  git submodule update --init .kindling
  if ! git -C .kindling pull --ff-only 2>/dev/null; then
    echo "sync-kindling: pull in .kindling failed (detached HEAD?); trying remote update ..." >&2
    git submodule update --remote .kindling || die "could not fast-forward .kindling submodule"
  fi

  # Re-apply kindling manifest
  local mf="$root/.kindling/kindling.manifest"
  [[ -f "$mf" ]] || die "missing .kindling/kindling.manifest"

  if [[ -f "$root/.kindling/.syncignore" ]]; then
    echo "sync-kindling: applying .kindling/.syncignore ..."
  fi

  local line src dst
  while IFS= read -r line; do
    src="${line%%|*}"
    dst="${line#*|}"
    src="$(echo "$src" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    dst="$(echo "$dst" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ "$src" == *..* || "$dst" == *..* ]] && die "invalid manifest path: $line"
    if is_kindling_syncignored "$root" "$src"; then
      continue
    fi
    if git ls-files --error-unmatch "$dst" >/dev/null 2>&1; then
      git rm -f "$dst" >/dev/null
    elif [[ -e "$root/$dst" ]]; then
      rm -f "$root/$dst"
    fi
  done < <(list_manifest_pairs "$mf")

  while IFS= read -r line; do
    src="${line%%|*}"
    dst="${line#*|}"
    src="$(echo "$src" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    dst="$(echo "$dst" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    if is_kindling_syncignored "$root" "$src"; then
      echo "sync-kindling: skipped (syncignore) $src"
      continue
    fi
    [[ -f "$root/.kindling/$src" ]] || die "missing file in .kindling/: $src"
    mkdir -p "$(dirname "$root/$dst")"
    cp -f "$root/.kindling/$src" "$root/$dst"
  done < <(list_manifest_pairs "$mf")

  rm -f "$root/KINDLING_REPO"
  chmod +x "$root/init-kindling" "$root/sync-kindling" 2>/dev/null || true
  chmod +x "$root/scripts/init-kindling.sh" "$root/scripts/sync-kindling.sh" 2>/dev/null || true

  git add .gitmodules .kindling 2>/dev/null || true
  git add . 2>/dev/null || true

  echo ""
  echo "sync-kindling: complete."
  echo "Next: review 'git status'; read .kindling/CHANGELOG.md for Consumer manual: bullets."
  echo "Then: git commit"
}

main "$@"
