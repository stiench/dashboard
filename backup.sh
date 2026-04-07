#!/usr/bin/env bash
set -euo pipefail

cp ~/git/MagicMirror/config/config.js ./

perl -i -pe "
  s#(\burl\s*:\s*)(['\"])[^'\"]*\2#\${1}\${2}REDACTED_URL\${2}#g;
  s#(\bclientId\s*:\s*)(['\"])[^'\"]*\2#\${1}\${2}REDACTED_CLIENT_ID\${2}#g;
  s#(\bclientSecret\s*:\s*)(['\"])[^'\"]*\2#\${1}\${2}REDACTED_CLIENT_SECRET\${2}#g;
  s#(\brefresh_token\s*:\s*)(['\"])[^'\"]*\2#\${1}\${2}REDACTED_REFRESH_TOKEN\${2}#g;
  s#(\bapiKey\s*:\s*)(['\"])[^'\"]*\2#\${1}\${2}REDACTED_API_KEY\${2}#g;
" ./config.js

git add .
git commit -m "Backup MagicMirror config.js"
git push
