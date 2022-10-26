#!/bin/sh
id=`grep ID .rm | cut -b 4-`
oldtrackname=""
while :;
do
  trackname=`lsof -n | grep mp3 | grep upload | grep ^mplayer | sed "s/.*upload.//"`

  test  `echo -n $trackname | wc -c` -gt 3 && hash=$trackname || hash="00000000000000000000000000000000"
  amixer=$(echo `grep SMASTER .rm | sed "s/^........//" | xargs -n 2 amixer get ` | grep % | awk -v RS=[ -v FS=] 'NR>1{print $1" " }' | grep %| tr -d '\n')
  disk=$(df -h | grep '/$' | awk -F ' ' '{print " D"$5}' | tr -d '\n')

  test "$hash" != "$oldtrackname" -a "$hash" != "00000000000000000000000000000000"  && wget --no-check-certificate -O /dev/null -o /dev/null --header="Content-Type: application/json" --post-data='{"jsonrpc": "2.0", "method": "new_track", "id":1, "params": ["'$id'", "'$hash' '"$amixer$disk"'", "'`date +%T`'", "'`date +%D`'"] }' http://$1

  oldtrackname=$trackname
  sleep 1
done
