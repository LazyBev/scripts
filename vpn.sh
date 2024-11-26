#!/bin/bash

set -e

sudo pacman -S networkmanager-openvpn
wget https://swupdate.openvpn.org/community/releases/openvpn-2.6.12.tar.gz
tar -xvzf openvpn-* cd openvpn-*/
./configure
make && make install
