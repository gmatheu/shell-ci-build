#!/usr/bin/env bash
set -eo pipefail
[[ "${DEBUG:-}" ]] && set -x

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] Linting %s...\n" "$1"
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] Linting %s...\n" "$1"
  exit 1
}

check() {
  local scripts=( "$@" )
  local build_dir=build
  mkdir -p "$build_dir"
  shellcheck "${scripts[@]}" || {
    shellcheck --format checkstyle "${scripts[@]}" > "$build_dir/checkstyle.xml" || echo
    fail "${scripts[@]}";
  }
  success "${scripts[@]}"

}

find_prunes() {
  local prunes="! -path './.git/*'"
  if [ -f .gitmodules ]; then
    while read module; do
      prunes="$prunes ! -path './$module/*'"
    done < <(grep path .gitmodules | awk '{print $3}')
  fi
  echo "$prunes"
}

find_cmd() {
  echo 'grep -rlw . --include=\*.{sh,zsh,bash} -e"#\!.*[sh]"'
}

check_all() {
  echo "Linting all executables and .sh files, ignoring files inside git modules..."
  local files=( "$(eval "$(find_cmd)")" )
  check ${files[@]}
}

check_all
