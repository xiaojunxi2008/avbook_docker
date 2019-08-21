# Docker AVBook
根据[avbook](https://github.com/guyueyingmu/avbook)编写的Dockerfile

## 使用说明：
    镜像已经上传到Dockerhub
    docker pull xjx2008/avbook:latest
    docker run -d -p 8999:8999 --name avbook avbook:xjx2008/avbook:latest (-p 映射端口默认是8999,如果有更改请注意)
    docker run -d -p 8999:8999 -e DB_USERNAME=xxxx -e DB_PWD=xxxx --name avbook xjx2008/avbook:latest(示例更改mysql用户名密码)
    然后你就可以通过 IP:8999 访问啦 (IP是自己的DockerHost主机IP,端口是映射的端口)
    因为我自己有云数据库,所以并没有把数据库整合进Docker,如果有需要的话后面我再把mysql也加入进去
### Dockerfile文件
* `FILE_PATH` 指定文件路径,默认为/var,可在docker build时传入参数更改
### docker—entrypoint.sh文件
    请把数据库链接替换成自己的,这些参数可以在docker run 时传入,也可以直接修改文件,重新打包
    (我提供了一个默认数据库链接,但只有select权限,只能打开首页,想要完全体验,请自己搭建数据库)
* `DB_HOST` 数据库链接
* `DB_PORT` 数据库端口
* `DB_NAME` 数据库名称
* `DB_USERNAME` 数据库用户名
* `DB_PWD` 数据库密码
* `NGINX_PORT` nginx监听端口,默认为8999
#### 容器内使用nginx转发
## 环境
    ubuntu 18.0
    php 7.2
    Composer 1.9-dev
    nginx 1.14.0
    php web 监听 127.0.0.1:8000
    nginx 监听 8999转发到8000
## 我是个小白,正在学习Docker,也不懂Php,所以Dockerfile写的很杂乱,如果有能优化的地方,希望大佬们指出
## 求Star⭐
![](http://i1.hoopchina.com.cn/hupuapp/bbs/72953558009175/thread_72953558009175_20190805114814_s_31983_o_w_440_h_440_37592.jpg?x-oss-process=image/resize,w_365/format,jpg)
# License
    The Docker AVBook is open-source software licensed under the MIT license.
