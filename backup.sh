#!/usr/bin/env bash
set -euo pipefail

cp ~/git/MagicMirror/config.js ./

perl -i -pe 's#(\burl\s*:\s*")[^"]*(")#${1}REDACTED_URL${2}#g' ./config.js
