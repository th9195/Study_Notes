



# 1- 官网



- 安装

``` html
https://clickhouse.com/docs/zh/getting-started/install/
```

- 包下载

``` html
https://repo.yandex.ru/clickhouse/rpm/stable/x86_64/
```

- 版本介绍
  - 版本号：20.5  final  支持多线程;
  - 版本号：20.6.3 支持explain执行计划；
  - 版本号：20.8 支持实时同步Mysql数据；



- 下载四个包

``` properties
clickhouse-client-21.7.3.14-2.noarch.rpm
clickhouse-common-static-21.7.3.14-2.x86_64.rpm
clickhouse-common-static-dbg-21.7.3.14-2.x86_64.rpm
clickhouse-server-21.7.3.14-2.noarch.rpm
```

- 安装

``` properties
sudo rpm -ivh *.rpm 
注意: 在安装clickhouse-server的时候需要输入默认用户的密码 （自己玩就直接回车）
```

- 查看安装情况

``` properties
rpm -pa| grep clickhouse
```

- 修改配置文件

``` properties
vim /etc/clickhouse-server/config.xml 打开listen : 
<listen_host>::</listen_host>
```

- 启动服务：
  - systemctl start clickhouse-server
  - systemctl restart clickhouse-server
  - systemctl stop  clickhouse-server



# 2- 哔哩哔哩资料(非常好)

``` properties
https://www.bilibili.com/video/BV1Yh411z7os?p=5
```

 

# 3- pySpark103

明文密码： BDvxkZtk

密问：c62d252111b9144d83ee95d4989faf7c0771c3368733037204da4c92594ea004



``` xml
<password_sha256_hex>65e84be33532fb784c48129675f9eff3a682b27168c0ea74
    4b2cf58ee02337c5</password_sha256_hex>
```



- 启动服务：
  - systemctl start clickhouse-server
  - systemctl restart clickhouse-server
  - systemctl stop  clickhouse-server





# 4- 安装后目录结果

- bin/  ===>		/usr/bin/
- conf/ ===>      /etc/clickhouse-server/
  - config.xml  : 服务配置
    - listen
  - users.xml ：参数配置（CPU、内存）
- lib/ ===>          /var/lib/clickhouse
- log/ ===>         /var/log/clickhouse