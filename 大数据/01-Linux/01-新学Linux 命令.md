# find指令
用于查找符合条件的文件
示例：

``` sql
find / -name 'ins*' #查找/目录下以文件名ins开头的文件 
find / -type f -size +100M #查找/目录下文件大小大于100M的文件
```



# grep命令
``` javascript
grep 命令可以对文件进行文本查询
grep lang anaconda-ks.cfg #在文件中查找lang
```

# ps命令

#**top**  查看哪个进程使用CPU过高

#**ps -ef | grep** 34405  查看该进程详情

``` shell
[hadoop@fdc08 ~]$ top  # 查看哪个进程使用CPU过高
top - 18:11:46 up 24 days,  2:27,  3 users,  load average: 29.19, 25.05, 21.52
Tasks: 647 total,   1 running, 646 sleeping,   0 stopped,   0 zombie
%Cpu(s): 18.4 us,  2.8 sy,  0.0 ni, 77.8 id,  0.2 wa,  0.0 hi,  0.8 si,  0.0 st
KiB Mem : 52806886+total, 58909756 free, 97759440 used, 37139968+buff/cache
KiB Swap:  4194300 total,  4194300 free,        0 used. 42918742+avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                              
34405 yarn      20   0   14.0g   5.0g  57204 S 297.2  1.0  11:51.00 java                                                 
39593 yarn      20   0 3159960   1.1g  56548 S 247.0  0.2   7:16.22 java                                                 
34409 yarn      20   0   13.9g   5.1g  57208 S 209.1  1.0  10:00.24 java                                                 
34408 yarn      20   0   14.0g   5.0g  57208 S 149.5  1.0  11:01.02 java                                                 
32451 yarn      20   0 7702672   2.7g  51772 S 110.8  0.5   6:38.54 java                                                 
34410 yarn      20   0   14.0g   5.0g  57204 S 106.3  1.0   7:00.06 java                                                 
22290 kafka     20   0   24.3g   1.5g  27204 S  86.4  0.3  13:17.89 java                                                 
40855 yarn      20   0 4412892   1.3g  56796 S  57.8  0.3   4:00.98 java                                                 
 5028 hbase     20   0   22.8g  11.8g  28236 S  49.1  2.3 156:33.67 java                                                 
57451 hadoop    20   0   25.4g   7.3g 122468 S  35.5  1.5   3194:20 prometheus                                           
33943 yarn      20   0 2889404 487128  51640 S   6.3  0.1   0:47.45 java                                                 
35451 yarn      20   0   13.8g  10.9g  56788 S   4.9  2.2  16:22.71 java                                                 
[hadoop@fdc08 ~]$ ps -ef | grep 34405  #查看该进程详情
yarn     34405 34160 99 18:07 ?        00:12:20 /usr/java/jdk1.8.0_144/bin/java -Xmx10871635848 -Xms10871635848 -XX:MaxDirectMemorySize=1207959552 -XX:MaxMetaspaceSize=268435456 -Dlog4j2.formatMsgNoLookups=true -Dlog.file=/data/yarn/container-logs/application_1669975154853_0002/container_e07_1669975154853_0002_01_000016/taskmanager.log -Dlog4j.configuration=file:./log4j.properties -Dlog4j.configurationFile=file:./log4j.properties org.apache.flink.yarn.YarnTaskExecutorRunner -D taskmanager.memory.framework.off-heap.size=134217728b -D taskmanager.memory.network.max=1073741824b -D taskmanager.memory.network.min=1073741824b -D taskmanager.memory.framework.heap.size=134217728b -D taskmanager.memory.managed.size=8053063800b -D taskmanager.cpu.cores=2.0 -D taskmanager.memory.task.heap.size=10737418120b -D taskmanager.memory.task.off-heap.size=0b -D taskmanager.memory.jvm-metaspace.size=268435456b -D taskmanager.memory.jvm-overhead.max=1073741824b -D taskmanager.memory.jvm-overhead.min=1073741824b --configDir . -Djobmanager.rpc.address=fdc03 -Dweb.port=0 -Djobmanager.memory.off-heap.size=134217728b -Dweb.tmpdir=/tmp/flink-web-a626393a-ce63-4f1b-8376-39d8dad39e3e -Djobmanager.rpc.port=37164 -Drest.address=fdc03 -Djobmanager.memory.jvm-overhead.max=214748368b -Djobmanager.memory.jvm-overhead.min=214748368b -Dtaskmanager.resource-id=container_1669975154853_0002_01_000016 -Dinternal.taskmanager.resource-id.metadata=fdc08:8041 -Djobmanager.memory.jvm-metaspace.size=268435456b -Djobmanager.memory.heap.size=1530082096b
hadoop   42374 25277  0 18:11 pts/1    00:00:00 grep --color=auto 34405
[hadoop@fdc08 ~]$ 
```





# 用户创建和密码设置

useradd 用户名
passwd  用户名

```  javascript
useradd  itheima #创建新用户itheima
passwd  itheima #设置用户itheima密码
```





# 用户删除
``` javascript
user -r 用户名
userdel -r itheima #删除用户itheima
```



# 网络状态查看命令netstat
``` javascript
netstat -nltp
```



# 查看某个端口挂在哪个进程上

``` shell
netstat -anp | grep 10000
netstat -anp | grep 9000 # clickhouse 端口

netstat -anp | grep 
```



# systemctl命令

``` javascript
systemctl start 服务名	开启服务
systemctl stop 服务名	关闭服务
systemctl status 服务名	显示服务状态
systemctl enable 服务名	设置开机自启动
systemctl disable 服务名	关闭开机自启动
```



# 网络操作

``` javascript
systemctl status network   # 查看网络服务状态 
systemctl stop network     # 停止网络服务
systemctl start network     # 启动网络服务
systemctl restart network   # 重启网络服务
```



# 防火墙操作
``` javascript
systemctl stop firewalld.service          #停止firewall
systemctl disable firewalld.service       #禁止firewall开机启动
systemctl status firewalld.service        #查看防火墙状态
```





# vim 命令行模式常用命令

| 命令 | 功能                        |
| ---- | --------------------------- |
| o    | 在当前行后面插入一空行      |
| O    | 在当前行前面插入一空行      |
| dd   | 删除光标所在行              |
| ndd  | 从光标位置向下连续删除 n 行 |
| yy   | 复制光标所在行              |
| nyy  | 从光标位置向下连续复制n行   |
| p    | 粘贴                        |
| u    | 撤销上一次命令              |
| gg   | 回到文件顶部                |
| G    | 回到文件末尾                |
| /str | 查找str                     |



# vim 底行模式常用命令

## 设置行号

``` javascript
:set nu 	设置行号
```



## 文本替换

``` javascript
:%s/旧文本/新文本/g	 文本替换
```



## 显示高亮

``` sql

```



## 取消高亮

``` sql
linux vim取消高亮显示:
:nohl即可
```



# curl命令行下直接获取当前IP信息



## curl cip.cc

``` javascript
[root@node01 ~]# curl cip.cc
IP	: 223.104.20.95
地址	: 中国  湖北  移动

数据二	: 湖北省 | 移动数据上网公共出口

数据三	: 

URL	: http://www.cip.cc/223.104.20.95
[root@node01 ~]# 

```



## curl -L tool.lu/ip

``` javascript
[root@node01 ~]# curl -L tool.lu/ip
当前IP: 223.104.20.95
归属地: 中国 湖北省 武汉市
[root@node01 ~]# 

[root@node01 ~]# curl -L https://tool.lu/ip
当前IP: 223.104.20.95
归属地: 中国 湖北省 武汉市
[root@node01 ~]# 


```



## curl myip.ipip.net

``` javascript
[root@node01 ~]# curl myip.ipip.net
当前 IP：223.104.20.95  来自于：中国 湖北   移动
[root@node01 ~]# 

```



## curl ipinfo.io

``` javascript
[root@node01 ~]# curl ipinfo.io
{
  "ip": "223.104.20.95",
  "city": "Wuhan",
  "region": "Hubei",
  "country": "CN",
  "loc": "30.5833,114.2667",
  "org": "AS9808 Guangdong Mobile Communication Co.Ltd.",
  "timezone": "Asia/Shanghai",
  "readme": "https://ipinfo.io/missingauth"
}[root@node01 ~]# 

```





# Linux创建任意大小的文件

``` shell
dd if=/dev/zero of=/export/data/testFile.txt bs=300M count=1


[root@node1 ~]# dd if=/dev/zero of=/export/data/testFile.txt bs=300M count=1
记录了1+0 的读入
记录了1+0 的写出
314572800字节(315 MB)已复制，1.29123 秒，244 MB/秒
[root@node1 ~]# cd /export/data/
[root@node1 data]# ls -shal 
总用量 601M
   0 drwxr-xr-x 2 root root  146 1月  11 14:27 .
   0 drwxr-xr-x 6 root root   82 12月 30 15:52 ..
300M -rw-r--r-- 1 root root 300M 1月  11 14:27 testFile.txt
[root@node1 data]# 


```





# nc(netcat)向某个端口发送数据

``` properties
# nc是netcat的简称，原本是用来设置路由器,我们可以利用它向某个端口发送数据
# 安装 nc
yum install -y nc

# 启动客户端工具发送消息
nc -lk 9999 
```



# 将一个字符串写入到文件中

```shell
[root@tanghui test]# tee ./test.json <<- 'EOF'
> {
> "name":"Tom","age":30
> }
> EOF
{
"name":"Tom","age":30 
}
[root@tanghui test]# ll
总用量 8
-rw-r--r-- 1 root root 26 6月  22 10:18 test.json
[root@tanghui test]# cat test.json 
{
"name":"Tom","age":30
}
[root@tanghui test]# 
```



# Linux 重启 /关机

- 重启

``` shell
reboot

init 6 
```

- 关机

``` shell
shutdown -h now

init 0
```

# 设置虚拟机的hostname

``` shell
vim /etc/hostname

## 编辑内容就是hostname 
node1
```



# 下载安装软件

- 下载

  ``` properties
   wget https://dl.grafana.com/oss/release/grafana-5.4.3-1.x86_64.rpm
  ```

  

- 安装rpm格式的软件

  ``` properties
  yum localinstall grafana-5.4.3-1.x86_64.rpm
  ```

  ``` properties
  rpm -ivh   xxxx.rpm
  ```

- 查看  rpm 软件

  ``` properties
  rpm -pa | grep clickhouse
  ```

  

# 给Linux用户设置权限

``` shell
chown -R hadoop:root spark-3.1.2-bin-hadoop3.2

# hadoop: 用户名
# root : 组名
# spark-3.1.2-bin-hadoop3.2 : 目录名称
```



# tail 查看文件尾部多少行信息

``` shell
tail -100 spark-hadoop-org.xxxx.xxx.xxx.xx.log.out
```





# 案例

