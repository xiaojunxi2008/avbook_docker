# Docker AVBook
根据[avbook](https://github.com/guyueyingmu/avbook)编写的Dockerfile
## 使用
    (镜像已经上传到Dockerhub)
    docker pull xjx2008/avbook:latest
    docker run -d -p 8999:8999 --name avbook xjx2008/avbook:latest
    启动之后会自动导入数据,请等待一会,使用docker logs avbook看到如下信息即完成
    Laravel development server started: <http://127.0.0.1:8000>
    然后你就可以通过 IP:PORT 访问啦 (IP是自己的DockerHost主机IP,PORT是映射的端口)
## 使用说明：
    请务必将nginx映射端口保持一致,例如 8999:8999 , 33323:33323
    
    如果需要连接容器内数据库,请打开3306端口,例如(3306端口映射不必保持一致)
    docker run -d -p 8999:8999 -p 3306:3306 --name avbook xjx2008/avbook:latest
    示例更改mysql密码为xxxx
    docker run -d -p 8999:8999 -p 3306:3306 -e DB_PWD=xxxx --name avbook xjx2008/avbook:latest
### Dockerfile文件
* `FILE_PATH` 指定文件路径,默认为/var,可在docker build时传入参数更改
### docker—entrypoint.sh文件
    这些参数可以在docker run 时传入,也可以直接修改文件,重新打包
* `DB_HOST` 数据库链接(默认为127.0.0.1)
* `DB_PORT` 数据库端口(默认为3306)
* `DB_NAME` 数据库名称(默认为avbook)
* `DB_USERNAME` 数据库用户名(默认为root)
* `DB_PWD` 数据库密码(默认为avbook111)
* `NGINX_PORT` nginx监听端口(默认为8999)
## 环境
    ubuntu 18.0
    php 7.2
    Composer 1.9-dev
    nginx 1.14.0
    MariaDB 10.1.41
    php web 监听 127.0.0.1:8000
    nginx 监听 8999转发到8000
# License
    The Docker AVBook is open-source software licensed under the MIT license.
