#!/bin/bash
set -euo pipefail

if [ -f "$HOME/$1" ];
then
  echo "Using cached $1."
else
  wget -O ~/$1 "https://github.com/SpaceManiac/SpacemanDMM/releases/download/$SPACEMAN_DMM_VERSION/$1"
  mkdir -p $HOME/spaceman_dmm
  cp ~/$1 $HOME/spaceman_dmm/$SPACEMAN_DMM_VERSION
  chmod +x ~/$1
fi

~/$1 --version
