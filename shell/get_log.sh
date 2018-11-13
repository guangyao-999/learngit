echo "解压文件 $1"


for file in `ls -t`
do
    name=`echo "${file#*.}"`
    if [ $name = "tar.gz" ];then
        echo $file
        break
    fi

done

tar -zxvf $file > /dev/null

pwd=`echo "${file%%.*}"`

echo $pwd
echo "获取日志"
cat $pwd/log/messages |grep librccvmm |grep -v exec_shell_cmd > log


if [ $# -lt 1 ];then
    echo "detail is not collect"
    exit 1
fi

echo "获取详细日志"
cat log |grep "$2" |tee detail_log


