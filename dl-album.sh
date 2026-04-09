#!/bin/bash

# requires jq
# arg 1: iCloud web album URL
# arg 2: folder to download into (optional)

clear

function curl_post_json {
	curl -sH "Content-Type: application/json" -X POST -d "@-" "$@"
}

function contains_exact {
	local needle="$1"
	shift

	for item in "$@"; do
		if [[ "$item" == "$needle" ]]; then
			return 0
		fi
	done

	return 1
}

printf "Getting iCloud Stream\n"
BASE_API_URL="https://p23-sharedstreams.icloud.com/$(echo $1 | cut -d# -f2)/sharedstreams"

CLEANUP_MISSING_FILES=false

if [[ -n "$2" ]] && pushd "$2" > /dev/null 2>&1; then
	CLEANUP_MISSING_FILES=true
fi

STREAM=$(echo '{"streamCtag":null}' | curl_post_json "$BASE_API_URL/webstream")
HOST=$(echo $STREAM | jq '.["X-Apple-MMe-Host"]' | cut -c 2- | rev | cut -c 2- | rev)

if [ "$HOST" ]; then
    BASE_API_URL="https://$(echo $HOST)/$(echo $1 | cut -d# -f2)/sharedstreams"
    STREAM=$(echo '{"streamCtag":null}' | curl_post_json "$BASE_API_URL/webstream")
fi

printf "Grabbing Large File Checksums\n"
CHECKSUMS=$(echo $STREAM | jq -r '.photos[] | [(.derivatives[] | {size: .fileSize | tonumber, value: .checksum})] | max_by(.size | tonumber).value')

printf "Adding Checksums to Array\n"
for CHECKSUM in $CHECKSUMS; do
    arrCHKSUM+=($CHECKSUM)
done
printf "Total Downloads: ${#arrCHKSUM[@]}\n"

# Dedup checksum to only include unique ids.
arrCHKSUM=($(printf "%s\n" "${arrCHKSUM[@]}" | sort -u))
printf "Unique Downloads: ${#arrCHKSUM[@]}\n"

printf "Streaming All Assets\n"
arrREMOTE_FILES=()
while read -r URL; do

	# Get this URL's checksum value, not all URL's will be downloaded as there are both the fill size AND the thumbnail link in the Assets stream.
	LOCAL_CHECKSUM=$(echo "${URL##*&}")

	# If the url's checksum exists in the large checksum array then proceed with the download steps.
	if [[ " ${arrCHKSUM[*]} " =~ " ${LOCAL_CHECKSUM} " ]]; then

			# Get the filename from the URL, first we delimit on the forward slashes grabbing index 6 where the filename starts.
			# then we must delimit again on ? to remove all the URL parameters after the filename.
			# Example: https://www.example.com/4/5/IMG_0828.JPG?o=param1&v=param2&z=param3....
			FILE=$(echo "$URL" | cut -d "/" -f6 | cut -d "?" -f1)
			arrREMOTE_FILES+=("$FILE")

			if [[ -f "$FILE" ]]; then
				printf "File %s already present. Skipping.\n" "$FILE"
			else
				curl -OJ "$URL"
			fi

	else
		echo "Skipping Thumbnail"
	fi

done < <(
	echo "$STREAM" \
	| jq -c '{photoGuids: [.photos[].photoGuid]}' \
	| curl_post_json "$BASE_API_URL/webasseturls" \
	| jq -r '.items | to_entries[] | "https://" + .value.url_location + .value.url_path + "&" + .key'
)

if [[ "$CLEANUP_MISSING_FILES" == true ]]; then
	printf "Removing Missing Local Files\n"
	while read -r LOCAL_FILE; do
		if ! contains_exact "$LOCAL_FILE" "${arrREMOTE_FILES[@]}"; then
			printf "Removing %s\n" "$LOCAL_FILE"
			rm -f -- "$LOCAL_FILE"
		fi
	done < <(find . -maxdepth 1 -type f -printf '%P\n')
fi

if [[ "$CLEANUP_MISSING_FILES" == true ]]; then
	popd > /dev/null
fi
wait
