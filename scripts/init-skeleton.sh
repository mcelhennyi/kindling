#!/usr/bin/env bash
# Run from a fresh clone of the skeleton repository: add .skeleton as submodule,
# materialize template files at repo root, remove the SKELETON_REPO marker from root.
set -euo pipefail

die() { echo "init-skeleton: $*" >&2; exit 1; }

# shellcheck source=skeleton-ignore.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skeleton-ignore.sh"

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

main() {
  local root url prev mf
  root="$(repo_root)"
  cd "$root"

  if [[ -f .gitmodules ]] && grep -qF '[submodule ".skeleton"]' .gitmodules 2>/dev/null; then
    echo "init-skeleton: already initialized (.skeleton submodule present)."
    echo "init-skeleton: working tree root is: $root"
    return 0
  fi

  if [[ -e .skeleton ]]; then
    die ".skeleton already exists but is not registered as a submodule. Remove or rename it, then retry."
  fi

  url="${SKELETON_SUBMODULE_URL:-}"
  if [[ -z "$url" ]]; then
    url="$(git remote get-url origin 2>/dev/null || true)"
  fi
  [[ -n "$url" ]] || die "set SKELETON_SUBMODULE_URL or add a git remote named origin"

  prev="$(git rev-parse HEAD)"
  echo "init-skeleton: pinning submodule to outer HEAD: $prev"

  local branch="${SKELETON_SUBMODULE_BRANCH:-}"
  if [[ -z "$branch" ]]; then
    branch="$(git remote show origin 2>/dev/null | sed -n '/HEAD branch/s/.*: //p' | tr -d '\r' || true)"
  fi
  [[ -n "$branch" ]] || branch="main"

  if git submodule add -b "$branch" "$url" .skeleton 2>/dev/null; then
    :
  elif git submodule add "$url" .skeleton 2>/dev/null; then
    :
  else
    die "git submodule add failed (try SKELETON_SUBMODULE_BRANCH or check URL/access)"
  fi

  git submodule update --init --recursive .skeleton

  if git -C .skeleton cat-file -e "${prev}^{commit}" 2>/dev/null; then
    git -C .skeleton checkout --detach "$prev"
    echo "init-skeleton: submodule checked out at $prev"
  else
    echo "init-skeleton: warning: outer HEAD $prev not found inside submodule; leaving submodule default checkout" >&2
  fi

  mf="$root/.skeleton/skeleton.manifest"
  [[ -f "$mf" ]] || die "submodule missing skeleton.manifest"

  if [[ -f "$root/.skeleton/.syncignore" ]]; then
    echo "init-skeleton: applying ignore list from .skeleton/.syncignore ..."
  fi

  local line src dst
  while IFS= read -r line; do
    src="${line%%|*}"
    dst="${line#*|}"
    src="$(echo "$src" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    dst="$(echo "$dst" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ "$src" == *..* || "$dst" == *..* ]] && die "invalid manifest path: $line"
    if is_syncignored "$root" "$src"; then
      continue
    fi
    if git ls-files --error-unmatch "$src" >/dev/null 2>&1; then
      git rm -f "$src" >/dev/null
    elif [[ -e "$root/$src" ]]; then
      rm -f "$root/$src"
    fi
  done < <(list_manifest_pairs "$mf")

  while IFS= read -r line; do
    src="${line%%|*}"
    dst="${line#*|}"
    src="$(echo "$src" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    dst="$(echo "$dst" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ "$src" == "SKELETON_REPO" || "$dst" == "SKELETON_REPO" ]] && continue
    if is_syncignored "$root" "$src"; then
      echo "init-skeleton: skipped (syncignore) $src"
      continue
    fi
    [[ -f "$root/.skeleton/$dst" ]] || die "missing file in submodule: .skeleton/$dst"
    mkdir -p "$(dirname "$root/$src")"
    cp -f "$root/.skeleton/$dst" "$root/$src"
  done < <(list_manifest_pairs "$mf")

  if [[ -f "$root/.skeleton/README.template.md" ]]; then
    if [[ ! -f "$root/README.md" ]] || cmp -s "$root/README.md" "$root/.skeleton/README.md" 2>/dev/null; then
      cp -f "$root/.skeleton/README.template.md" "$root/README.md"
    fi
  fi

  rm -f "$root/SKELETON_REPO"

  chmod +x "$root/develop" "$root/scripts/serve-docs.sh" 2>/dev/null || true

  git add -f .gitmodules .skeleton
  git add -A

  echo ""
  echo "init-skeleton: complete."
  echo "  - Nested template: .skeleton/ (submodule)"
  echo "  - Materialized manifest paths at repo root (respecting .skeleton/.syncignore)"
  echo "  - Submodule-only files (CHANGELOG, INIT.MD, init/sync wrappers, …) stay under .skeleton/ only"
  echo "  - Removed SKELETON_REPO from root (consumer project)"
  echo ""
  echo "Next: review 'git status', customize README.md, run init-project skill, commit."
  echo "Sync later: bash .skeleton/scripts/sync-skeleton.sh"
  echo "Working tree root (stay here for day-to-day work): $root"
  cd "$root"
}

main "$@"
