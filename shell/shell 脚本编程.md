### 1、执行数学运算 

```
#使用expr
expr 3 + 4  
expr 3 \\* 4

#使用[]
[] 俩边都要有空格
var1=$[1 + 5]
```
### 2、结构化命令
```
（1）
if command  # command 执行成功，返回0， 则执行then
then
    commands
elif command
then
    commands
else     # 属于elif代码块
    commands
fi

（2）
if command; then
    commands
fi

# 判断执行条件
(4)
if [condition]
then
    commands
fi

(5) case 模块
case variable in 
case1)
    commands;;
case2)
    commands;;
*)
    default commands;;
esac

（6）for模块

IFS=$'\n'   #这样for循环就可以通过换行弄出单个条目


for var in list
do
    commands
done

c语言风格
for (( i=1; i <= 10; i++))
do
    commands
done

(7) while 模块

while [ condition ]
do
    commands
done

(8) until模块

until [ condition ]
do
    commands
done

（9） break
break 2 # 跳出第二层循环
done > output.txt  # 将循环的输出重定向到txt

```

### 3、比较
1、数值比较
```
-eq #相等
-ge #大于或等于
-gt #大于
-le #小于或等于
-lt #小于
-ne #不等于
```
2、字符串比较
```
= 
!=
<
>
-n #长度是否非0
-z #长度是否为0
```

3、文件比较
```
-d #检查file是否存在并是一个目录
-e #检查file是否存在
-f #检查file是否存在并且是一个文件
-r #是否存在并可读
-s #是否存在并非空
-w #是否存在并可写
-x #是否存在并可执行
-O #是否存在并属于当前用户
-G #是否存在并且默认组与当前用户相同
file1 -nt file2 #检查file1是否比file2新
file1 -ot file2 #检查file1是否比file2旧

```

4、复合条件测试
```
[ condition1 ] && [ condition2 ]
[ condition1 ] || [ condition2 ]
```

### 4、用户输入

$0 脚本名， $1 第一个参数，依次类推  
$* 获取所有参数，将所有参数当成一个整体  
$@ 获取所有参数，可以使用for循环遍历
$# 所有参数的数量

shift 移动变量

```
count=1
while [ -n "$1" ]
do
    echo "Parameter #$count = $1"
    count=$[ $count + 1 ]
    shift
done
    
```

read 获取用户输入
```
-p       "Enter your number"
-t 5     5秒等待输入后退出
-s       隐藏用户输入

```
文件读取
```
cat test | while read line
do
        echo "$line"
        count=$[ $count + 1 ]
done

```
脚本中重定向输入   
exec 0< testfile

### 5、重定向输出
(1) 重定向错误输出和输出信息到不同文件
  2> error 1> info

(2) 重定向错误输出和输出信息到相同文件
&> info

(3) 脚本里面重定向输出，文件描述符

1、临时重定向

```
echo "this is a error" >&2

2>log
```

2、永久重定向

```
#!/bin/bash
exec 1 > infolog
exec 2 > errlog

echo "this is a error info" >&2

```

3、关闭文件描述符(能用的文件描述符只有9个)  

exec 3>&-

4、同时输出到文件和屏幕  
tee 命令   
date | tee testfile

### 6、信号处理
**1、常见信号**

信号  | 值    | 描述
------| --------|----------
 1 |  SIGHUP | 挂起进程
 2 |  SIGINT | 终止进程
 3 |  SIGQUIT | 停止进程
 9 | SIGKILL  | 无条件终止进程
 18 | SIGTSTP | 暂停进程

 
**2、trap 捕获信号**
```
a=1
trap "echo 'get the Ctrl C first'" SIGINT # change signal
while [ $a -lt 10]
do
    sleep 1
    a=$[ $a + 1 ]
done

trap "echo 'get the Ctrl C second'" SIGINT  #change signal
while [$a -lt 20]
do
    sleep 1
    a=$[ $a + 1 ]
done

trap -- SIGINT # recovery signal

```

**3、在非控制台下运行脚本**

这样子当终端退出时，这个脚本还能正常的运行，并且会把STDOUT和STDERR 消息重定向到nohup.out 的文件中。

    nohup ./test.sh & 
### 7、作业管理

**查看作业**  

    jobs -l

**重启停止的作业**

    bg # 后台模式重启
    fg # 以前台模式重启

**定时作业**

```
at -M -f test1.sh now  #-M 屏蔽输出信息 -f 指定文件
at -M -f test2.sh tomorrow
at -M -f test3.sh 13:30

```
**列出等待作业**
    
    atq
**删除等待作业**  
    
    atrm

**cron时间表**
格式

    min hour dayofmonth month dayofweek command

```
15 10 * * * command # 每天的10.15分执行该指令， *位全选
15 10 * * 1 command # 每周一的10.15执行该指令。
15 10 1 * * command # 每个月的第一天执行该指令
```
**crontab -l 列出cron时间表里面的任务**

**/etc/cron.\*ly 下面的目录就是会循环自动执行的脚本** 

---
### 8、sed 用法
**1、sed 函数的主要作用就是字符串替换**

```
-e   #可以使用多个命令
-f   # 指定文件

例子:
sed -e 's/brown/green/; s/dog/cat/' data.txt
sed -f scrip.sed data.txt

# 替换脚本
cat scrip.sed
s/brown/green/
s/fox/elephant/

```
**2、指定行替换**

行寻址替换
```
#只替换第二行
sed '2s/dog/cat/' data.txt

#替换从第二行开始的所有行
sed '2,$s/dog/cat/' data.txtvir

```
文本模式过滤替换   
先匹配到指定行，然后在替换行里面的匹配字符
```
sed '/root/s/bash/csh/' /etc/passwd
```

**3、命令组合**  

使用 {} 括起来执行多条地址指令
```
sed '2{s/test/no/
    s/dog/cat/
}' data.txt
```




### 9、gawk 流处理程序

1、简单操作
选项  | 描述    | 用法
------| --------|----------
 -F fs | 使用指定分隔符分割 | gawk -F: '{print $1}' data.txt
 -f filename | 从指定文件获取程序 | gawk -F: -f scrip.gawk /etc/passwd
 

```
$0  整个文本行
$1  文本行中第一个数据段
$2  文本行中第二个数据段
$n  文本行中第n个数据段

```
gawk文本程序
```
cat scrip.gawk

BEGIN {
print "this is a test"
FS=":"
}

{
    text = "this is a test"
    print $1 text $6
}
END {
print "this is the last"
}
```

2、数据处理前后操作
使用BEGIN 可以在数据处理前执行  
使用END 可以在数据处理后执行

```
gawk 'BEGIN {print "the begin"}; {print $0} END {print "the end"}' data.txt

```

3、


### 10、函数
bash shell 会把函数当作一个小型脚本，运行结束时会返回一个退出状态码，使用$?来确定函数的退出状态码。

**使用return 返回**：

*这个退出状态码必须使用 $?接收
可以使用echo 来返回字符串*
```
函数退出状态码默认是最后一条指令的执行结果。
退出的状态码必须是0~255

```
**函数变量的作用域**
```
在任何地方定义的变量默认都是全局变量，包括函数内部定义的
使用local声明变量为局部变量

local temp
```


### 11、正则匹配
---
**1、特殊字符**   
使用时需要用 反斜杠 '\' 转义
.*[]^${}\+?|()/  

**2、锚字符**  

'^' ： 行首匹配  
'$' ： 行尾匹配  
'.' :  可以充当为任意字符  
'*' :  *前面的字符可以不出现或者出现多次  
'?' :  ？前面的字符可以出现0次或1次  
'+' :  + 前面的字符必须至少出现1次  
'{}' : 指定区间上下限 {m,n}   
'|' : 相当于逻辑or  



例子：  
sed '/^$/d' data  删除文本空白行    
echo "ik" | sed -n '/ie*k'/p'   e可以出现多次或者不出现

**3、字符组**

(1)可以匹配不同大小写的字符和数字   
(2)也可以使用逃脱字符排除

例子：   
echo "YeS" | sed -n '/[Yy][Ee][Ss]/p'  
sed -n '/[0123]/p' data   
sed -n '/[^ch]at/p' data     
[0-9]{4}   匹配4个0~9范围的数字






























### 脚本

**1、自动创建用户脚本**
```
input = "users.csv"
while IFS=',' read -r userid name 
do 
    echo $name
done < "$input"


``` 

**2、选项参数获取模板**
```
while [ -n "$1" ]
do
        case "$1" in
                -a)
                echo "-a option";;
                -b)
                param="$2"
                echo "-b option, param = $param"
                shift;;
                *)
                echo "other";;
        esac
        shift
done

```

**3、临时将屏幕输出重定向到某个文件**

```
exec 3>&1
exec 1>testfile

echo " this is a test"

exec 1>&3
echo "this is normal"
```

**4、临时重定向输入从某个文件获取输入**

```
exec 6<&0
exec 0< testfile

count=1
while read line
do
    echo "Line: $line"
    count=$[ $count + 1 ]
done

exec 0<&6
read -p " Are you done now?" answer
case $answer in
Y|y) echo "Goodbye";;
N|n) echo "this is the end";;
esac

```

**5、重文件获取输入，输出到sql文件**

```
#!/bin/bash
#read file and create INSERT for SQL

outfile='mem.sql'
IFS=','
while read name sex
do 
	cat >> $outfile << EOF
name:$name,sex:$sex
EOF
done < ${1}
```

**6、获取指定目录下面的所有文件**
```
j=0
for i in `find /opt -name "*.base"`
do
    list[$j]=$i
    j=`expr $j + 1`
done
```
**遍历数组 ** 
```
for i in ${list[@]}
do
    commands
done
```


### 踩坑集合

1、return 返回值只能是0~255， 返回字符串哪些要用echo   

2、接受函数使用 temp=$(function1)

3、使用return 返回的只能用  $?  接收

4、window下面编辑的到linux要转换格式，不然会有令牌错误问题

5、sed 分隔可以使用任意符号

6、echo -e 才可以使用转义字符