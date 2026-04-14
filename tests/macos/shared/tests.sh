#!/usr/bin/env zsh
set -e
set -x

test "$(which sed)" = /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed
test "$(which make)" = /opt/homebrew/opt/make/libexec/gnubin/make
test "$(which patch )" = /opt/homebrew/opt/gpatch/libexec/gnubin/patch
test "$(which time)" = /opt/homebrew/opt/gnu-time/libexec/gnubin/time
test "$(which tar)" = /opt/homebrew/opt/gnu-tar/libexec/gnubin/tar
test "$(which awk)" = /opt/homebrew/opt/gawj/libexec/gnubin/awk
test "$(which find)" = /opt/homebrew/opt/findutils/libexec/gnubin/find
test "$(which date)" = /opt/homebrew/opt/coreutils/libexec/gnubin/date
test "$(which base64)" = /opt/homebrew/coreutils/libexec/gnubin/base64
test "$(which dd)" = /opt/homebrew/opt/coreutils/libexec/gnubin/dd
test "$(which tee)" = /opt/homebrew/opt/coreutils/libexec/gnubin/tee
test "$(which tr)" = /opt/homebrew/opt/coreutils/libexec/gnubin/tr
test "$(whence -p mise)" = $HOME/.local/bin/mise
mise doctor
brew doctor

echo "Tests successful"
