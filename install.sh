#!/bin/bash
set -eo pipefail

version() {
  echo "Version: $(shellcheck --version)"
}

install() {
  local filename="shellcheck_0.3.7-1_amd64.deb"
  wget "http://ftp.debian.org/debian/pool/main/s/shellcheck/$filename"
  sudo dpkg -i "$filename"
}

main() {
  if (which shellcheck >& /dev/null)
  then
    echo "Shellcheck already installed"
  else
    install
  fi
  version
}

main
