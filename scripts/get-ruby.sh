# This bash file is meant to be source'd, not executed.

SITE_WEBDEV_RUBY_VERS=2.4.3

if ! rvm version | grep -q '(latest)'; then
  rvm get stable
fi

echo "RVM current: $(rvm current)"
if rvm current | grep -Fq "ruby-$SITE_WEBDEV_RUBY_VERS"; then
  echo "Using $(rvm current) (rvm $(rvm version | awk '{print $2}'))"
elif rvm list | grep -Fq "ruby-$SITE_WEBDEV_RUBY_VERS"; then
  rvm use $SITE_WEBDEV_RUBY_VERS
elif [[ -z "$1" || "$1" == "--install" ]]; then
  rvm install $SITE_WEBDEV_RUBY_VERS
else
  echo "ERROR: ruby $SITE_WEBDEV_RUBY_VERS isn't locally available and --install option was not specified."
  return 1
fi

if [[ ! -e ~/.rvmrc ]] || ! grep -q rvm_silence_path_mismatch_check_flag ~/.rvmrc;  then
    echo rvm_silence_path_mismatch_check_flag=1 >> ~/.rvmrc
    echo "Configured RVM so it doesn't complain if it isn't first in PATH"
fi

return 0
