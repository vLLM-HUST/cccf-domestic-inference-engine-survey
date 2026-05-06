#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)
current_user=$(id -un)

repair_file() {
	local path="$1"
	if [[ ! -f "$path" ]]; then
		return 0
	fi

	if [[ -w "$path" ]] && [[ $(stat -c '%U' "$path") == "$current_user" ]]; then
		return 0
	fi

	if [[ $(stat -c '%U' "$path") == "$current_user" ]]; then
		chmod u+w "$path"
		return 0
	fi

	local dir tmp
	dir=$(dirname "$path")
	if [[ ! -w "$dir" ]]; then
		echo "skip: parent directory not writable: $path" >&2
		return 1
	fi

	tmp=$(mktemp "$dir/.copilot-perm-fix.XXXXXX")
	cp "$path" "$tmp"
	chmod u+w "$tmp"
	mv -f "$tmp" "$path"
}

while IFS= read -r -d '' path; do
	repair_file "$path"
done < <(
	find "$repo_root" \
		\( -path "$repo_root/.git/objects" -o -path "$repo_root/.git/objects/*" -o -path "$repo_root/build" -o -path "$repo_root/build/*" \) -prune -o \
		-type f \( ! -user "$current_user" -o ! -writable \) -print0
)

echo "permission repair complete"