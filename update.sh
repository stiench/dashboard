#!/usr/bin/env bash
set -e

cd ~/git/MagicMirror
git pull
node --run install-mm

for dir in ~/git/MagicMirror/modules/*/; do
	module_name="${dir%/}"
	module_name="${module_name##*/}"

	if [[ "$module_name" == "default" ]]; then
		continue
	fi

	if [[ -d "$dir/.git" ]]; then
		git -C "$dir" pull
	fi

	if [[ -f "$dir/package.json" ]]; then
		npm --prefix "$dir" install
	fi
done