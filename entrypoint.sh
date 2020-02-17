#!/bin/sh

lock_file=Gemfile.lock

function install_bundler() {
  # Confirm existance of Gemfile.lock in working directory (/code by default)
  if [ ! -f $lock_file ]; then
    echo "No \"$lock_file\" found in `pwd`"
    exit 1
  fi

  # Check that the Bundler version used to generate the lock file is installed
  if ! bundle version &> /dev/null; then
    version=$(awk '/^BUNDLED WITH$/ { getline; print $1; }' $lock_file)
    echo "$lock_file was generated with a different Bundler version..."
    gem install -qN bundler:$version
  fi
}

if [ "${1:0:1}" = "-" ]; then
  install_bundler

  set -- bundle audit check $@
elif [ "$1" = "check" ]; then
  install_bundler

  set -- bundle audit $@
elif [ "$1" = "audit" ]; then
  [ "$2" = "check" ] && install_bundler

  set -- bundle $@
elif [ "$1 $2 $3" = "bundle audit check" ]; then
  install_bundler
fi

exec $@
