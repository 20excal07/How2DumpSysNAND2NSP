#!/bin/bash
IFS=$'\n'

SPLITSIZE=0xFFFF0000
CHUNKSIZE=0x8000
inFile=$1
out=$2
if [ -z $2 ] ; then
 out=.
fi

if [ $# -lt 1 ] ; then
 echo usage: $0 "<inputFile>" "[outputDir]"
else
 FILESIZE=$(stat -c%s ${inFile})
 if [ $((FILESIZE)) -le $((SPLITSIZE)) ] ; then
  echo Input file is equal or less than 4 GB, no need to split!
  exit;
 fi

 NUM_OF_SPLIT=$(( (FILESIZE / SPLITSIZE) + 1 ))
 inFileBase=$(basename ${inFile})
 nspDir="${out}/${inFileBase}"
 
 mkdir -p ${nspDir}
 mkdirRet=$?
 if [ $((mkdirRet)) -ne 0 ] ; then
  echo "Filename conflict detected, renaming..."
  nspDir="${out}/_${inFileBase}"
  mkdir -p ${nspDir}
 fi
 sleep 0.5

 PART=0
 SEEK=0
 while [ $((PART)) -lt $((NUM_OF_SPLIT)) ]; do
  partStr=$(printf "%02d" $PART)
  echo Splitting part ${partStr} of $(printf "%02d" $((NUM_OF_SPLIT - 1)))...
  dd if="${inFile}" skip=$((SEEK)) iflag=skip_bytes count=$((SPLITSIZE/CHUNKSIZE)) bs=$((CHUNKSIZE)) of=${nspDir}/${partStr} status=progress
  ((SEEK+=SPLITSIZE))
  ((PART++))
 done
fi
