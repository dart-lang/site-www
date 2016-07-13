#!/bin/bash

response=$(curl -s -L -D - $1 -o /dev/null);
if [[ $response =~ "HTTP/1.1 404 Not Found" ]]; then
  echo "NOT FOUND: $1"
  exit 1
else
  echo "OK: $1"
  exit 0
fi