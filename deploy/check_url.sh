#!/bin/bash

response=$(curl -s -L -D - $1 -o /dev/null);
if [[ $response =~ "HTTP/1.1 404 Not Found" ]]; then
  echo ""
  echo "NOT FOUND: $1"
  echo ""
  exit 1
else
  echo -n "."
  exit 0
fi