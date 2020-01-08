## 1、nginx_uwsgi_flask
基于 nginx + uwsgi + flask 的一个班级管理系统

### 操作
1、构建base下面的基础镜像
2、在docker-nginx-uwsgi-flask-py3下面执行rebuild.sh 脚本，构建镜像和容器
3、在宿主机服务器上面先导入Htai数据库
4、在http://172.28.93.100:8888/user/login/ 的web界面访问
5、使用账号1 密码1管理员角色登录web进行用户创建和权限分配


### 学习点
- 基本dockerfile文件的编写
- flask框架的初步学习
1、项目框架搭建
2、前端学习
3、MVT模型学习
- mysql数据库的学习
1、数据库基本操作
2、一对一、一对多、多对多以及关联表的操作
3、数据库导出
```
mysqldump -uroot -p --databases Htai > Htai.sql
```
4、数据库导入
```
mysql -uroot -p < Htai.sql
```

## 主要结构
1、使用 nginx + uwsgi + flask 搭建基础镜像
2、使用dockerfile构建应用镜像
3、启动容器运行flask
docker run -p 9999:6666 -d my_web_app

### 参考链接
[Dockerfile搭建环境并打包应用](https://www.cnblogs.com/beiluowuzheng/p/10220860.html)
[完整的flask项目](https://blog.csdn.net/qq_33196814/article/details/80866094)

