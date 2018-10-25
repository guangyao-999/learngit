#!/bin/bash
#
#autor:sgy
#

DATE=$(date +%y%m%d)
FILE=archive$DATE.tar.gz
CONFIG_FILE=/opt/sgy/Back_up
DESTFILE=/opt/sgy/$FILE

########## Main Script#################
if [ -f $CONFIG_FILE ]
then 
    echo
else
    echo "CONFIF_FILE  does not exists"
    exit 1
fi

FILE_NO=1
exec < $CONFIG_FILE
read FILE_NAME

while [ $? -eq 0 ]
do
    if [ -f $FILE_NAME -o -d $FILE_NAME ]
    then
        FILE_LIST="$FILE_LIST $FILE_NAME"
    else
        echo "$FILE_NAME, does not exists"
        echo "continue other file"
    fi
    FILE_NO=$[$FILE_NO + 1]
    read FILE_NAME
done

echo "start archive...."
echo
tar -zcvf $DESTFILE $FILE_LIST 2>/dev/null
echo "Archive completed"
echo "Resulting archive file is :$DESTFILE"
echo

exit 