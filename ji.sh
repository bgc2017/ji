#!/bin/bash

for i in $(cat 1); do
ID=$(echo $i|awk -F'-' '{print $1}')
TITLE=$(echo $i|awk -F'-' '{print $2}')
CHAODAI=$(echo $i|awk -F'-' '{print $3}')
AUTHOR=$(echo $i|awk -F'-' '{print $4}')

for j in $i/*.txt; do
#echo "perl -C 1.pl  $j $ID $TITLE $CHAODAI $AUTHOR"
perl ji.pl "$j" $ID $TITLE "$CHAODAI" $AUTHOR
done

done
