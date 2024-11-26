#!/bin/bash

set -e

sudo pacman -Syu go gcc libpcap libnetfilter_queue
sudo pacman -S pkg-config
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
source ~/.bashrc
go install github.com/bettercap/bettercap@latest
ls ~/go/bin/bettercap
sudo mv ~/go/bin/bettercap /usr/local/bin/
sudo setcap cap_net_raw,cap_net_admin=eip /usr/local/bin/bettercap
