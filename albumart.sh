#!/bin/bash

#  albumart.sh - A wrapper for addcover.sh (add logging)
#  Homepage: https://github.com/rucker/scripts
#  Author: Rick Ucker 
#
# Dependencies:
# addcover.sh (http://github.com/taq/addcover)

Date=$(eval date +%Y%m%d)
WorkingDir=~/Music
LogsDir=~/code/scripts/logs
eyed3LogFile=$LogsDir/eyed3-$Date.log
eyed3ErrLogFile=$LogsDir/eyed3-$Date.err.log
addcoverLogFile=$LogsDir/addcover-$Date.log
addcoverErrLogFile=$LogsDir/addcover-$Date.err.log
AddLogFile=$ScriptsDi
echo "Removing existing cover images..."
find $WorkingDir -name *.mp3 -exec eyeD3 --remove-images {} \+ > $eyed3LogFile 2> $eyed3ErrLogFile
echo "Adding new cover images..."
find $WorkingDir -name *mp3 -exec addcover.sh > $addcoverLogFile 2> $addcoverErrLogFile
