#!/bin/bash

while read line; do

  ARGS=( $line )
  CLIENTRANDOM=`echo ${ARGS[5]} | sed -e 's/\[//g' | sed -e 's/\]//g' | sed -e 's/,/ /g'`
  SECRET=`echo ${ARGS[11]} | sed -e 's/\[//g' | sed -e 's/\]//g' | sed -e 's/,/ /g'`
  CR=( `echo $CLIENTRANDOM` )
  SE=( `echo $SECRET` )
  
  echo -n "CLIENT_RANDOM "
  for cr in "${CR[@]}"; do
    printf "%02x" "$cr"
  done
  echo -n " "
  for se in "${SE[@]}"; do
    printf "%02x" "$se"
  done
  echo ""

done < "${1:-/dev/stdin}"
