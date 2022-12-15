#!/usr/bin/env bash
# Use this file locally to update Node PPA checksum value in the Dockerfile
set -eu -o pipefail

NODE_PPA="node_ppa.sh"
curl -fsSL https://deb.nodesource.com/setup_lts.x -o "$NODE_PPA"
_checksum=$(shasum -a 256 $NODE_PPA)
read -a _fname_arr <<< "${_checksum}" # Read in string output as array
_checkonly="${_fname_arr%:*}" # Remove filename portion of checksum output
echo "NODE_SHA256="$_checkonly"; \\"
rm $NODE_PPA
