#!/usr/bin/env bash
# Use this file locally to update Node PPA checksum value in the Dockerfile
set -eu -o pipefail

NODE_PPA="node_ppa.sh"
curl -fsSL https://deb.nodesource.com/setup_lts.x -o "$NODE_PPA"
echo "NODE_SHA256="$(shasum -a 256 $NODE_PPA)"; \\"
rm $NODE_PPA
