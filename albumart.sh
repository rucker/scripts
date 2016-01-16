#!/bin/bash

# albumart.sh - A wrapper for addcover.sh (add logging)
# Homepage: https://github.com/rucker/scripts
# Author: Rick Ucker
#
# Dependencies:
# addcover.sh (http://github.com/taq/addcover)
# eyed3 (http://eyed3.nicfit.net)

needDep() {
  echo "Missing dependency $1. Exiting..."
  exit 1
}

if [[ "$(which eyeD3)" == "" ]]; then
  needDep "eyeD3"
fi

thisScriptDir="$(dirname $(readlink -f "$0"))/"
if [[ ! -f "$thisScriptDir""addcover.sh" ]]; then
  echo "$thisScriptDir""addcover.sh"
  needDep "addcover.sh"
fi

if [[ $# == 0 ]]; then
  echo "Please specify a directory."
  exit 1
fi

workingDir=$1
date=$(eval date +%Y%m%d)
logsDir=$thisScriptDir/logs
eyed3LogFile=$logsDir/eyed3-$date.log
eyed3ErrLogFile=$logsDir/eyed3-$date.err.log
addcoverLogFile=$logsDir/addcover-$date.log
addcoverErrLogFile=$logsDir/addcover-$date.err.log

echo "Removing existing cover images..."
find $workingDir -name *.mp3 -exec eyeD3 --remove-images {} \+ > $eyed3LogFile 2> $eyed3ErrLogFile
echo "Adding new cover images..."
find $workingDir -name *mp3 -exec addcover.sh > $addcoverLogFile 2> $addcoverErrLogFile
