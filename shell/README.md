主要记录了在工作中学习到的常用shell脚本使用。

### 1、add_linux_user.sh
通过读取 users.csv 里面记录的用户信息创建linux用户

### 2、create_qemu_vm.sh
利用kvm虚拟化快速创建一个新的ubuntu，或者centos等linux系统，以及利用现有模板快速克隆  

	1、create new vm server
    2、restart new vm server
    3、clone vm server

**注意：**创建新的linux系统时 create new vm server，使用cdrom的方式创建，通过返回的端口，利用vnc工具登陆，配置完系统后，在调用restart new vm server修改为正常启动方式


### 3、auto_ssh.sh
生成ssh密钥，使得下次登陆可以直接免密登陆，提高开发效率
	
    $ ./ssh   192.168.1.1
    

### 4、 list_dir.sh
列出 $PATH 下面的可执行文件的数量

### 5、Daily_Archive.sh
按日期保存文件