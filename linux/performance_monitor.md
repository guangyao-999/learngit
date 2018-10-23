## linux系统下常见的性能测试工具
---


### 1、UnixBench

Unixbench-5.1.2.tar.gz下载地址：http://202.115.33.13/soft/test/unixbench/unixbench-5.1.2.tar.gz

    tar -xzvf unixbench-5.1.2.tar.gz
    
    cd unixbench-5.1.2
    
    yum -y  install perl-Time-HiRes #更新组件

perl安装包： 使用perl -MCPAN -e shell  进入交互命令行 install安装Time-HiRes

阅读README文件，得知如果不需要进行图形测试或者不在图形化界面下测试，则将Makefile文件中GRAPHICS_TEST = defined注释掉，我的是在46行。

    make
    ./Run
看到run文件后，输入 ./Run 执行命令对VPS进行性能测试就开始了，最后跑完将会有一个分数在底部出现。通常情况下1000分以上的VPS是性能较好的。

参考链接：https://blog.csdn.net/gatieme/article/details/50912910
https://blog.csdn.net/u013943420/article/details/73888770

### 2、 nmon
参考链接：
- 使用  
https://blog.csdn.net/reblue520/article/details/53689656
- 性能指标说明

https://blog.csdn.net/he_jian1/article/details/41039709/

### 3、 lm_sensors查看cpu温度

```
1、安装:sudo yum install -y lm_sensors
2、检测传感器：sudo sh -c "yes|sensors-detect"
3、查看温度：sensors
```