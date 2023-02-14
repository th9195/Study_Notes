## 1- 打印GC 日志信息

``` reStructuredText
-yD env.java.opts=
"-XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:/data/hzw/log/ProssesEndGC.log"
```

![1676279833460](assets/1676279833460.png)



## 2- 设置jvm内存

``` reStructuredText
-yD taskmanager.memory.jvm-metaspace.size=1024m
```

![1676279833460](assets/1676279833460.png)



## 3- 设置管理内存

``` reStructuredText
-yD taskmanager.memory.managed.size=2048m
```

![1676280185491](assets/1676280185491.png)





