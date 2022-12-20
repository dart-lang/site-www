#!/usr/bin/env bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
END='\033[0m'


function blue() {
  echo -e "$BLUE$1$END"
}

function red() {
  echo -e "$RED$1$END"
}

function yellow() {
  echo -e "$YELLOW$1$END"
}

function base_dir() {
  echo $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
}
