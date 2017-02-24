#!/usr/bin/env bash

set -ue
set -o pipefail

BASEDIR=${1:-$(pwd)}
BINDIR=$BASEDIR/bin
mkdir -p $BINDIR
TMPDIR=$BASEDIR/.tmp.install_plink
mkdir -p $TMPDIR

cd $TMPDIR

case $OSTYPE in
  darwin*)
    URL="https://www.cog-genomics.org/static/bin/plink170223/plink_mac.zip"
    ;;
  linux*)
    URL="https://www.cog-genomics.org/static/bin/plink170223/plink_linux_x86_64.zip"
    ;;
esac

wget -c $URL -O plink.zip
unzip plink.zip plink
cp plink $BINDIR

$BINDIR/plink --version

cd $BASEDIR
rm -rf $TMPDIR
