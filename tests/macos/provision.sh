#!/bin/zsh
set -e
ipsw=$(find . -name '*.ipsw' | gum choose --select-if-one)
if [[ -z "$ipsw" ]];then gum log -l error "Missing ipsw file";exit 1;fi
macosvm --disk disk.img,size=50g --aux aux.img --restore "$ipsw" vm.json
macosvm -g vm.json
cp -c disk.img master.img

