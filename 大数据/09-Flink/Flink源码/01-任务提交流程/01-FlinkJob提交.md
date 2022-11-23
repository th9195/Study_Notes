

提交命令 : 

``` shell
flink run -t yarn-per-job jar --port 9999
```



yarn-per-job 新老版本写法

```  properties
老版本(<= 1.10): flink run -m yarn-cluster -c xxxx.java  xxxxx.jar
新版本(>= 1.11): flink run -t yarn-per-job -c xxxx.java  xxxxx.jar
```



