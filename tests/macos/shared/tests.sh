#!/usr/bin/env zsh
set -e
set -x

test "$(whence -p sed)" = /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed
test "$(whence -p make)" = /opt/homebrew/opt/make/libexec/gnubin/make
test "$(whence -p patch )" = /opt/homebrew/opt/gpatch/libexec/gnubin/patch
test "$(whence -p time)" = /opt/homebrew/opt/gnu-time/libexec/gnubin/time
test "$(whence -p tar)" = /opt/homebrew/opt/gnu-tar/libexec/gnubin/tar
test "$(whence -p awk)" = /opt/homebrew/opt/gawj/libexec/gnubin/awk
test "$(whence -p find)" = /opt/homebrew/opt/findutils/libexec/gnubin/find
test "$(whence -p date)" = /opt/homebrew/opt/coreutils/libexec/gnubin/date
test "$(whence -p base64)" = /opt/homebrew/coreutils/libexec/gnubin/base64
test "$(whence -p dd)" = /opt/homebrew/opt/coreutils/libexec/gnubin/dd
test "$(whence -p tee)" = /opt/homebrew/opt/coreutils/libexec/gnubin/tee
test "$(whence -p tr)" = /opt/homebrew/opt/coreutils/libexec/gnubin/tr
test "$(whence -p mise)" = $HOME/.local/bin/mise
mise doctor
brew doctor

echo "Tests successful"
