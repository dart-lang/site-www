#!/usr/bin/env bash

RED='\e[0;31m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
GRAY='\e[0;37m'
END='\e[0m'


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
