#!/bin/bash
#
#@autohor sgy
#
#collect log

HOST=192.168.1.1
REMOTE=192.168.1.2
LOG=/opt/sgy/log/
DATE=$(date +%Y%m%d)
FILE=$LOG$DATE.tar.gz

mkdir -p $LOG
tar zcvf $FILE -C /var/ --exclude=log/lastlog log  &> /dev/null

j=0
for i in `ls -rt $LOG`
do
    list[$j]=$i
    j=`expr $j + 1`
done

if [ $j -gt 5 ]
then
    rm -rf $LOG${list[0]}
fi

while [ 1 ]
do
    `scp $FILE root@$REMOTE:/opt/sgy/log/$HOST/ `
    result=`echo $?`
    
    if [ $result -eq 0 ]
    then
        exit 1
    fi
    sleep 3
done

exit 0
