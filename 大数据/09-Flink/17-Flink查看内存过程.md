## 1- 确定节点,containerID

- 在CDH上查看对应的Job 并打开taskManager 列表，并选择一个taskManager

![1676270445299](assets/1676270445299.png)

## 2- ssh 登陆该服务器

![1676270502751](assets/1676270502751.png)

## 3- 查询进程ID

- 根据containerID 查询 进程ID
- containerID   :  container_1671428673955_0719_01_000003 

![1676270608434](assets/1676270608434.png)

## 4- 查询top信息

- 根据进程ID 查询top信息

![1676270684437](assets/1676270684437.png)



## 5- jinfo 命令 



## 6- jmap命令

- jmap -heap  PID
- jmap -histo PID

``` properties
#查看整个JVM内存状态 
jmap -heap [pid]
#要注意的是在使用CMS GC 情况下，jmap -heap的执行有可能会导致JAVA 进程挂起
 
#查看JVM堆中对象详细占用情况
jmap -histo [pid]
 
#导出整个JVM 中内存信息
jmap -dump:format=b,file=文件名 [pid]
```



![1676278274859](assets/1676278274859.png)

![1676278247011](assets/1676278247011.png)









