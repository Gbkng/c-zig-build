#!/usr/bin/env sh

# ref: https://github.com/ziglang/zig/issues/9323#issuecomment-1646590552

# - create a JSON array of JSON objects from .cache/cdb, and let a void object at
# the end.
# - populate void JSON object with ??? (seems brittle)
# - format JSON with jq
# - filter out lines with "no-default-cofig"

(echo "["; cat .cache/cdb/*; echo "{}]") |
  perl -0777 -pe 's/,\n\{\}//igs' |
  jq . |
  grep -v 'no-default-config' > compile_commands.json
