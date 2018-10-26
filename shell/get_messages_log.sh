#!/bin/bash
#
#author:sgy
#

while [ -n "$1" ]
do
        case "$1" in
            -h)
            remote_ip="$2"
            shift;;
            -k)
            key="$2"
            shift;;
            *)
            echo ;;
        esac
        shift
done

file="${remote_ip}-${key}.log"
path=`pwd`
if [ -d $file ]
then
    echo "$remote_ip_$key file is exists, recover it!"
fi

cat > ./result.sh << EOF
echo "------------------------------------------"
echo "lessons dir:"
ls -l /opt/lessons/
echo "------------------------------------------"
df
echo "-------------------------------------------"
echo "log info:"
cat /var/log/messages |grep "$key"
EOF

scp -o StrictHostKeyChecking=no $path/result.sh $remote_ip:/root
rm -f $file
ssh -o StrictHostKeyChecking=no $remote_ip 'sh /root/result.sh'|tee -a $file





