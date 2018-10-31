### linux 开发过程中常用指令及问题定位工具
----

#### 1、常用简单指令

```
1、快速创建大文件
fallocate filename -l 3G

2、屏蔽和恢复某个ip的icmp包
iptables -I INPUT -s 192.168.1.1 -p icmp -j ACCEPT/DROP

3、tar包压缩与解压缩
解压：tar zxvf file.tar.gz
压缩：tar zcvf file.tar.gz Dirname

4、挂载iso文件
mount -o loop -t iso9660 /Centos.iso /file

5、清除内存缓存
echo "3" > /proc/sys/vm/drop_caches 清除内存缓存

6、dd命令读写操作
dd if=/dev/zero of=/opt/sgy bs=1024 count=1
dd if=/opt/sgy of=/dev/null bs=1024 count=1
seq 1000000 | xargs -i dd if=/dev/zero of={}.dat bs=1024 count=1 # 随机生成100w个小文件

7、查看文件或者命令所属的rpm包
rpm -qf /bin/ls

8、watch 轮询监控指令执行结果
watch -n 1 "ls /root"

9、查看进程间关系
pstree -p pid

10、网络带宽限制
# 下载安装包
sudo yum install wondershaper  
# 限速
sudo wondershaper eth0 1000 500
# 解除限速
sudo wondershaper clear eth0

11、内存查看
#查看服务器型号、序列号：

dmidecode|grep "System Information" -A9|egrep  "Manufacturer|Product|Serial"  

#Linux 查看内存的插槽数,已经使用多少插槽.每条内存多大

dmidecode|grep -A5 "Memory Device"|grep Size|grep -v Range

#Linux 查看内存的频率

dmidecode|grep -A16 "Memory Device"|grep 'Speed' 











```



#### 2、系统功能使用

##### 1、 系统关机时执行脚本
```
1.关机时执行某个脚本的具体思路

（1）在文件夹/etc/init.d/下创建关机时需要执行的脚本file_name；

（2）分别在文件夹/etc/rc0.d/和/etc/rc6.d/下创建该该脚本文件的链接文件K07file_name：

sudo ln -s /etc/init.d/file_name /etc/rc0.d/K07file_name
sudo ln -s /etc/init.d/file_name /etc/rc6.d/K07file_name

（3）在文件夹/var/lock/subsys/下生成与file_name同名的文件
sudo  mkdir -p /var/lock/subsys/
sudo  touch /var/lock/subsys/file_name

说明：关键字K07仅需要在文件夹/etc/rc0.d/和/etc/rc6.d/内添加，在/etc/init.d/和
/var/lock/subsys/里面不需要添加
```


---

#### 3、vim实用快捷键
```
shift  +   $^ 移到句首句尾
ctrl   +   n  补全函数
shift  +   <> 缩进
ESC    +   ！ 执行命令
ESC    +   o  回车换行

```




