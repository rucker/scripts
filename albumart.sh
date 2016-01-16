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

WorkingDir=$1
Date=$(eval date +%Y%m%d)
LogsDir=$thisScriptDir/logs
eyed3LogFile=$LogsDir/eyed3-$Date.log
eyed3ErrLogFile=$LogsDir/eyed3-$Date.err.log
addcoverLogFile=$LogsDir/addcover-$Date.log
addcoverErrLogFile=$LogsDir/addcover-$Date.err.log
AddLogFile=$ScriptsDi

echo "Removing existing cover images..."
find $WorkingDir -name *.mp3 -exec eyeD3 --remove-images {} \+ > $eyed3LogFile 2> $eyed3ErrLogFile
echo "Adding new cover images..."
find $WorkingDir -name *mp3 -exec addcover.sh > $addcoverLogFile 2> $addcoverErrLogFile
