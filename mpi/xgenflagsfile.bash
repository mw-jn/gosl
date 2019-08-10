#!/bin/bash

set -e

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'MINGW32_NT-6.2' ]]; then
   platform='windows'
elif [[ "$unamestr" == 'MINGW64_NT-10.0' ]]; then
   platform='windows'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='darwin'
fi

echo "   platform = $platform"

if [[ $platform == 'windows' ]]; then
    echo "MPI doesn't work on Windows at this time"
    exit 1
fi

CFLAGS=`mpicc -showme:compile`
LDFLAGS=`mpicc -showme:link`

FLAGS_FILE="xautogencgoflags.go"

echo "// Copyright 2016 The Gosl Authors. All rights reserved." > $FLAGS_FILE
echo "// Use of this source code is governed by a BSD-style" >> $FLAGS_FILE
echo "// license that can be found in the LICENSE file." >> $FLAGS_FILE
echo "" >> $FLAGS_FILE
echo "// *** NOTE: this file was auto generated by all.bash ***" >> $FLAGS_FILE
echo "// ***       and should be ignored                    ***" >> $FLAGS_FILE
echo "" >> $FLAGS_FILE
echo "// +build !windows" >> $FLAGS_FILE
echo "" >> $FLAGS_FILE
echo "package mpi" >> $FLAGS_FILE
echo "" >> $FLAGS_FILE
echo "/*" >> $FLAGS_FILE
echo "#cgo CFLAGS: $CFLAGS" >> $FLAGS_FILE
echo "#cgo LDFLAGS: $LDFLAGS" >> $FLAGS_FILE
echo "*/" >> $FLAGS_FILE
echo "import \"C\"" >> $FLAGS_FILE