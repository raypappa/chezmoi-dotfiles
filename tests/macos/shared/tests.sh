#!/usr/bin/env zsh
set -e
set -x

brew_prefix=$(brew --prefix)
test "$(whence -p sed)" = "$brew_prefix/opt/gnu-sed/libexec/gnubin/sed"
test "$(whence -p make)" = "$brew_prefix/opt/make/libexec/gnubin/make"
test "$(whence -p patch)" = "$brew_prefix/opt/gpatch/libexec/gnubin/patch"
test "$(whence -p time)" = "$brew_prefix/opt/gnu-time/libexec/gnubin/time"
test "$(whence -p tar)" = "$brew_prefix/opt/gnu-tar/libexec/gnubin/tar"
test "$(whence -p awk)" = "$brew_prefix/opt/gawk/libexec/gnubin/awk"
test "$(whence -p find)" = "$brew_prefix/opt/findutils/libexec/gnubin/find"
test "$(whence -p date)" = "$brew_prefix/opt/coreutils/libexec/gnubin/date"
test "$(whence -p base64)" = "$brew_prefix/opt/coreutils/libexec/gnubin/base64"
test "$(whence -p dd)" = "$brew_prefix/opt/coreutils/libexec/gnubin/dd"
test "$(whence -p tee)" = "$brew_prefix/opt/coreutils/libexec/gnubin/tee"
test "$(whence -p tr)" = "$brew_prefix/opt/coreutils/libexec/gnubin/tr"
test "$(whence -p mise)" = $HOME/.local/bin/mise
mise doctor
brew doctor

echo "Tests successful"
