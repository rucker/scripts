#!/bin/bash

#  replaygain.sh - A wrapper for mp3gain 
#  Homepage: https://github.com/rucker/scripts
#  Author: Rick Ucker 
#
#  Run this script to add mp3gain values to mp3 files in a directory 
#  and its subdirectories. Both album mode and track mode are supported.
#
# Dependencies:
# mp3gain (http://mp3gain.sourceforge.net/)

thisScript=$(basename $(readlink -nf $0))
usage="Usage: $thisScript directory [options]"
date=$(eval date +%Y%m%d)
workingDir=""
scriptsDir=$HOME/code/scripts
mp3LogFile=$scriptsDir/logs/mp3gain-$date.tsv
flacLogFile=$scriptsDir/logs/metaflac-$date.log
errLogFile=$scriptsDir/logs/mp3gain-$date.err.log
mp3gainOpts="-T -k -o "
mp3NamePattern="*.mp3"
metaflacOpts="--add-replay-gain"
flacNamePattern="*.flac"
findOpts="-type d -print0"

while [[ $# > 0 ]]
do
  arg="$1"
  if [[ -d $arg ]]
  then
    workingDir="$(readlink -f $arg)"
  else
    mp3gainOpts=$mp3gainOpts$arg
  fi
  shift
done

show_usage() {
  echo $usage
  echo "Use -h or --help for full list of options."
}
show_full_options() {
  echo $usage
  echo "Options:"
  echo "-a		Album mode (mp3gain). Treat all files in a given directory as tracks from the same album and apply album gain to all of them."
  echo "-r		Track mode (mp3gain). Apply track leveling to each individual file."
  echo $'\nEither -a or -r is required, but both cannot be used together.'
}

if [[ $mp3gainOpts =~ .*(-h|help).* ]]
then
  show_full_options
  exit 1
elif ! [[ $mp3gainOpts =~ .*(-a|-r).* ]]
then
  show_usage
  exit 1
elif [[ $mp3gainOpts =~ .*-a.* ]] && [[ $mp3gainOpts =~ .*-r.* ]]
then
  show_usage
  exit 1
fi
if [[ $workingDir == "" ]]
then
  show_usage
  exit 1
fi

process_dir() {
  echo "Processing replaygain for mp3 files in "$@""
  cd "$@"
  if ls $mp3NamePattern 1> /dev/null 2>&1; then
    mp3gain $mp3gainOpts $mp3NamePattern >> $mp3LogFile 2>> $errLogFile
  elif ls $flacNamePattern 1> /dev/null 2>&1
  then
    metaflac $metaflacOpts $flacNamePattern >> $flacLogFile 2>> $errLogFile
    metaflac --list $flacNamePattern | grep REPLAYGAIN>> $flacLogFile 2>> $errLogFile
  else
    echo "No matching files in this directory."
  fi
}
if [[ $mp3gainOpts =~ .*-a.* ]]
then
  echo "Using album mode for each subdirectory of $workingDir"
  find $workingDir/* $findOpts | while read -d $'\0' -r dir
    do
      process_dir "$dir"
    done
  process_dir $workingDir
else
  echo "Using track mode for all tracks in $workingDir"
  process_dir "$workingDir"
fi
