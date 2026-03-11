#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./patch_github_directions.sh [-f|--force] [-d|--github-dir DIR]

Copy markdown direction files from this repository's .github into the target
.github directory. Files inside any review-directions folder are excluded.
Matching target files are overwritten, and missing target files are created.
Target files with no matching source stay unchanged.

A backup archive of overwritten target files is created under the caller's ./tmp
directory first.

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

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source_github_dir="$script_dir/.github"
work_root="$(pwd -P)"

if [[ ! -d "$source_github_dir" ]]; then
  echo "Error: source .github directory does not exist: $source_github_dir" >&2
  exit 1
fi

if [[ "$github_dir_input" = /* ]]; then
  github_dir_abs="$github_dir_input"
else
  github_dir_abs="$work_root/$github_dir_input"
fi
github_dir_abs="$(realpath "$github_dir_abs")"

case "$github_dir_abs" in
  "$work_root"|"$work_root"/*)
    ;;
  *)
    echo "Error: target directory must be inside the current working directory: $work_root" >&2
    exit 1
    ;;
esac

if [[ ! -d "$github_dir_abs" ]]; then
  echo "Error: target directory does not exist: $github_dir_abs" >&2
  exit 1
fi

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
backup_dir="$work_root/tmp"
backup_path="$backup_dir/directions-backup-${timestamp}.tar.gz"

source_files=()
while IFS= read -r -d '' file_path; do
  source_files+=("$file_path")
done < <(find "$source_github_dir" -type d -name 'review-directions' -prune -o -type f -name '*.md' -print0 | sort -z)

if [[ "${#source_files[@]}" -eq 0 ]]; then
  echo "No source markdown files found under $source_github_dir."
  exit 0
fi

source_matches=()
target_matches=()
new_targets=()

for source_file in "${source_files[@]}"; do
  relative_path="$(realpath --relative-to="$source_github_dir" "$source_file")"
  target_file="$github_dir_abs/$relative_path"
  if [[ -f "$target_file" ]]; then
    source_matches+=("$source_file")
    target_matches+=("$target_file")
  else
    source_matches+=("$source_file")
    target_matches+=("$target_file")
    new_targets+=("$target_file")
  fi
done

if [[ "${#target_matches[@]}" -eq 0 ]]; then
  echo "No source markdown files are available to sync into $github_dir_abs."
  exit 0
fi

files_to_update=()
source_to_update=()
existing_files_to_backup=()
for index in "${!target_matches[@]}"; do
  if [[ ! -f "${target_matches[$index]}" ]] || ! cmp -s "${source_matches[$index]}" "${target_matches[$index]}"; then
    source_to_update+=("${source_matches[$index]}")
    files_to_update+=("${target_matches[$index]}")
    if [[ -f "${target_matches[$index]}" ]]; then
      existing_files_to_backup+=("${target_matches[$index]}")
    fi
  fi
done

echo "Source directory: $source_github_dir"
echo "Target directory: $github_dir_abs"
echo "Source files considered: ${#target_matches[@]}"
echo "Files that need updates: ${#files_to_update[@]}"
echo "New target files to create: ${#new_targets[@]}"

if [[ "${#files_to_update[@]}" -eq 0 ]]; then
  echo "All matching target files are already up to date."
  exit 0
fi

if [[ "$force" -ne 1 ]]; then
  for file_path in "${files_to_update[@]}"; do
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
for file_path in "${existing_files_to_backup[@]}"; do
  relative_paths+=("$(realpath --relative-to="$work_root" "$file_path")")
done

backup_rel=""
if [[ "${#relative_paths[@]}" -gt 0 ]]; then
  tar -czf "$backup_path" -C "$work_root" "${relative_paths[@]}"
  backup_rel="$(realpath --relative-to="$work_root" "$backup_path")"
fi

for index in "${!files_to_update[@]}"; do
  mkdir -p "$(dirname -- "${files_to_update[$index]}")"
  cp "${source_to_update[$index]}" "${files_to_update[$index]}"
done

if [[ -n "$backup_rel" ]]; then
  echo "Done. Synced ${#files_to_update[@]} files from source .github. Backup: $backup_rel"
else
  echo "Done. Synced ${#files_to_update[@]} files from source .github. No existing files required backup."
fi
