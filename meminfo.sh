#!/bin/sh
# see more http://blog.yufeng.info/archives/2456

for PROC in `ls /proc/|grep "^[0-9]"`
do
  if [ -f /proc/$PROC/statm ]; then
      TEP=`cat /proc/$PROC/statm | awk '{print ($2)}'`
      RSS=`expr $RSS + $TEP`
  fi
done

RSS=`expr $RSS \* 4`
PageTable=`grep PageTables /proc/meminfo | awk '{print $2}'`
SlabInfo=`cat /proc/slabinfo |awk 'BEGIN{sum=0;}{sum=sum+$3*$4;}END{print sum/1024/1024}'`

LibSo=`pmap $(pgrep bash) | tail -n 1 | awk '{print $2}'`
 
echo "RSS "$RSS"KB", "PageTable "$PageTable"KB", "SlabInfo "$SlabInfo"MB"
echo "RSS include LibSo, may calc many times "$LibSo

printf "rss+pagetable+slabinfo=%sMB\n" `echo $RSS/1024 + $PageTable/1024 + $SlabInfo|bc`
free -m
