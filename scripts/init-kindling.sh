#!/usr/bin/env bash
# Initialize a Hearth plugin repo with the two-layer Kindling setup.
#
# Step 1: skeleton layer  — adds .skeleton/ submodule + process tooling
# Step 2: kindling layer  — adds .kindling/ submodule + plugin templates/rules
#
# Run from the plugin repo root (after creating an initial commit and setting origin).
# See INIT.MD for the full walkthrough.
set -euo pipefail

die() { echo "init-kindling: $*" >&2; exit 1; }

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
  # Step 1: ensure skeleton layer is present
  # -----------------------------------------------------------------------
  if [[ ! -f .gitmodules ]] || ! grep -qF '[submodule ".skeleton"]' .gitmodules 2>/dev/null; then
    echo "init-kindling: Step 1 — .skeleton/ not present; running init-skeleton first ..."

    local skel_url skel_branch skel_script
    skel_url="${SKELETON_SUBMODULE_URL:-git@github.com:mcelhennyi/.skeleton.git}"
    skel_branch="${SKELETON_SUBMODULE_BRANCH:-main}"

    # Prefer the bundled copy if we are running from a kindling clone; fall back to curl.
    skel_script="$(dirname "${BASH_SOURCE[0]}")/init-skeleton.sh"
    if [[ -f "$skel_script" ]]; then
      SKELETON_SUBMODULE_URL="$skel_url" \
      SKELETON_SUBMODULE_BRANCH="$skel_branch" \
        bash "$skel_script"
    else
      SKELETON_SUBMODULE_URL="$skel_url" \
      SKELETON_SUBMODULE_BRANCH="$skel_branch" \
        bash <(curl -fsSL "https://raw.githubusercontent.com/mcelhennyi/.skeleton/main/scripts/init-skeleton.sh")
    fi

    echo "init-kindling: Step 1 complete — skeleton layer initialized."
    echo "init-kindling: Commit skeleton layer before continuing:"
    echo "  git add -A && git commit -m 'chore: init skeleton'"
  else
    echo "init-kindling: Step 1 — .skeleton/ already present, skipping skeleton init."
  fi

  # -----------------------------------------------------------------------
  # Step 2: add .kindling/ submodule
  # -----------------------------------------------------------------------
  if [[ -f .gitmodules ]] && grep -qF '[submodule ".kindling"]' .gitmodules 2>/dev/null; then
    echo "init-kindling: .kindling/ submodule already registered; skipping submodule add."
  else
    if [[ -e .kindling ]]; then
      die ".kindling already exists but is not a registered submodule. Remove or rename it, then retry."
    fi

    local kindling_url kindling_branch
    kindling_url="${KINDLING_SUBMODULE_URL:-git@github.com:mcelhennyi/kindling.git}"
    kindling_branch="${KINDLING_SUBMODULE_BRANCH:-main}"

    echo "init-kindling: Step 2 — adding .kindling/ submodule from $kindling_url ..."
    if git submodule add -b "$kindling_branch" "$kindling_url" .kindling 2>/dev/null; then
      :
    elif git submodule add "$kindling_url" .kindling 2>/dev/null; then
      :
    else
      die "git submodule add failed for .kindling (check KINDLING_SUBMODULE_URL/access)"
    fi
    git submodule update --init --recursive .kindling
  fi

  # -----------------------------------------------------------------------
  # Step 3: apply kindling manifest to consumer root
  # -----------------------------------------------------------------------
  local mf="$root/.kindling/kindling.manifest"
  [[ -f "$mf" ]] || die ".kindling/kindling.manifest not found; is the submodule initialized?"

  echo "init-kindling: Applying kindling manifest to consumer root ..."

  # Remove stale files listed in manifest (respecting syncignore)
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

  # Copy manifest files from .kindling/ to consumer root
  while IFS= read -r line; do
    src="${line%%|*}"
    dst="${line#*|}"
    src="$(echo "$src" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    dst="$(echo "$dst" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    if is_kindling_syncignored "$root" "$src"; then
      echo "init-kindling: skipped (syncignore) $src"
      continue
    fi
    [[ -f "$root/.kindling/$src" ]] || die "missing file in .kindling/: $src"
    mkdir -p "$(dirname "$root/$dst")"
    cp -f "$root/.kindling/$src" "$root/$dst"
    echo "init-kindling: copied $src -> $dst"
  done < <(list_manifest_pairs "$mf")

  # Remove KINDLING_REPO marker from consumer root (it stays in .kindling/)
  rm -f "$root/KINDLING_REPO"

  chmod +x "$root/init-kindling" "$root/sync-kindling" 2>/dev/null || true
  chmod +x "$root/scripts/init-kindling.sh" "$root/scripts/sync-kindling.sh" 2>/dev/null || true

  echo ""
  echo "init-kindling: complete."
  echo "  - .skeleton/ submodule: skeleton process tooling"
  echo "  - .kindling/ submodule: Hearth plugin templates + rules"
  echo "  - Kindling manifest files materialized at repo root"
  echo ""
  echo "Next: git add -A && git commit -m 'chore: init kindling'"
  echo "Sync later: ./sync-kindling"
}

main "$@"
