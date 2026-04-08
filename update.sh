#!/usr/bin/env bash
set -e

cd ~
pm2 stop mm.sh

cd ~/git/MagicMirror
git pull
node --run install-mm

for dir in ~/git/MagicMirror/modules/*/; do
	module_name="${dir%/}"
	module_name="${module_name##*/}"
	module_updated=false

	if [[ "$module_name" == "default" ]]; then
		continue
	fi

	if [[ -d "$dir/.git" ]]; then
		old_head="$(git -C "$dir" rev-parse HEAD)"
		git -C "$dir" pull
		new_head="$(git -C "$dir" rev-parse HEAD)"

		if [[ "$old_head" != "$new_head" ]]; then
			module_updated=true
		fi
	fi

	if [[ "$module_updated" == true && -f "$dir/package.json" ]]; then
		npm --prefix "$dir" install
	fi
done

cd ~
pm2 start mm.sh

