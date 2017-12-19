# This bash file is meant to be source'd, not executed.
#
# Until site-www has it's own setup, use the one from site-webdev

export WEBDEV_REPO=../site-webdev

if [[ -d $WEBDEV_REPO ]]; then
  source $WEBDEV_REPO/scripts/env-set.sh
else
  echo "WARNING: expected to find webdev repo at $WEBDEV_REPO, but none found."
  echo "WARNING: running local copy of setup script."

  # This is a copy of the site-webdev script. It is embedded here so that
  # we don't force all users to clone site-webdev. This isn't DRY, but it is temporary.
  
  if [[ -z "$(type -t rvm)" ]]; then
      echo "ERROR: rvm not installed. See site-webdev README. Skipping setup."
  elif [[ -z "$(type -t nvm)" ]]; then
      echo "ERROR: nvm not installed. See site-webdev README. Skipping setup."
  elif [[ -z "$NGIO_ENV_DEFS" || "$1" == "--reset" ]]; then
      export NGIO_ENV_DEFS=1
      export ANSI_YELLOW="\033[33;1m"
      export ANSI_RESET="\033[0m"
      echo -e "${ANSI_YELLOW}Setting environment variables from scripts/env-set.sh${ANSI_RESET}"

      nvm use 8

      # Configure RVM so it doesn't complain if it isn't first in your PATH:
      RVMRC=~/.rvmrc
      RVM_SILENCE_PATH=rvm_silence_path_mismatch_check_flag
      if [[ ! -r $RVMRC ]] || ! grep -q $RVM_SILENCE_PATH $RVMRC;  then
          echo $RVM_SILENCE_PATH=1 >> $RVMRC
      fi
      rvm use 2.4.2

      export NGIO_REPO=../angular.io
      export NG_REPO=../angular
      export NGDOCEX=examples/ng/doc
      export ACX_REPO=../angular_components

      if [ ! $(type -t travis_fold) ]; then
          # In case this is being run locally. Turn travis_fold into a noop.
          travis_fold () { true; }
      fi
      export -f travis_fold

      case "$(uname -a)" in
          Darwin\ *) _OS_NAME=macos ;;
          Linux\ *) _OS_NAME=linux ;;
          *) _OS_NAME=linux ;;
      esac
      export _OS_NAME

      : ${TMP:=$HOME/tmp}
      : ${PKG:=$TMP/pkg}
      export TMP
      export PKG

      if [[ -z "$(type -t dart)" && ! $PATH =~ \/dart-sdk ]]; then
          export DART_SDK="$PKG/dart-sdk"
          # Updating PATH to include access to Dart bin.
          export PATH="$PATH:$DART_SDK/bin"
          export PATH="$PATH:$HOME/.pub-cache/bin"
      fi

      if [[ -z "$(type -t content_shell)" && ! $PATH =~ \/content_shell ]]; then
          export PATH="$PATH:$PKG/content_shell"
      fi
  fi
fi
