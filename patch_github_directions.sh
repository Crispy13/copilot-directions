#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./patch_github_directions.sh [-f|--force] [-d|--github-dir DIR]

Overwrite every .md file under the target .github directory, except files inside
any review-directions folder. A backup archive is created under the caller's
./tmp directory first.

Examples:
  ./patch_github_directions.sh
  ./patch_github_directions.sh --force
  ./patch_github_directions.sh --github-dir ./tmp/test_github --force
USAGE
}

force=0
github_dir_input=".github"

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -f|--force)
      force=1
      shift
      ;;
    -d|--github-dir)
      if [[ "$#" -lt 2 ]]; then
        echo "Missing argument for $1" >&2
        usage
        exit 1
      fi
      github_dir_input="$2"
      shift 2
      ;;
    --github-dir=*)
      github_dir_input="${1#*=}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

work_root="$(pwd -P)"

if [[ "$github_dir_input" = /* ]]; then
  github_dir_abs="$github_dir_input"
else
  github_dir_abs="$work_root/$github_dir_input"
fi
github_dir_abs="$(realpath "$github_dir_abs")"

if [[ ! -d "$github_dir_abs" ]]; then
  echo "Error: target directory does not exist: $github_dir_abs" >&2
  exit 1
fi

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
backup_dir="$work_root/tmp"
backup_path="$backup_dir/directions-backup-${timestamp}.tar.gz"

files=()
while IFS= read -r -d '' file_path; do
  files+=("$file_path")
done < <(find "$github_dir_abs" -type d -name 'review-directions' -prune -o -type f -name '*.md' -print0 | sort -z)

if [[ "${#files[@]}" -eq 0 ]]; then
  echo "No markdown files found under $github_dir_abs."
  exit 0
fi

echo "Target directory: $github_dir_abs"
echo "Files to overwrite: ${#files[@]}"

if [[ "$force" -ne 1 ]]; then
  for file_path in "${files[@]}"; do
    printf '%s\n' "$(realpath --relative-to="$work_root" "$file_path")"
  done
  read -r -p "Proceed to overwrite these files? (y/N) " answer
  case "$answer" in
    y|Y)
      ;;
    *)
      echo "Cancelled."
      exit 1
      ;;
  esac
fi

mkdir -p "$backup_dir"
relative_paths=()
for file_path in "${files[@]}"; do
  relative_paths+=("$(realpath --relative-to="$work_root" "$file_path")")
done

tar -czf "$backup_path" -C "$work_root" "${relative_paths[@]}"
backup_rel="$(realpath --relative-to="$work_root" "$backup_path")"

for file_path in "${files[@]}"; do
  relative_path="$(realpath --relative-to="$work_root" "$file_path")"
  cat > "$file_path" <<EOF
---
updated: $timestamp
updated_by: patch_github_directions.sh
path: $relative_path
---

# Updated Directions

This file was overwritten by patch_github_directions.sh on $timestamp (UTC).

A backup of the previous file set was saved to: $backup_rel
EOF
done

echo "Done. Updated ${#files[@]} files. Backup: $backup_rel"
