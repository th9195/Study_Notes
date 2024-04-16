split -a 2 -d -b 22188 out.txt child



``` shell
split -a 2 -d -b 1M app.log.10 child
-a 2  后缀是2位
-d  后缀是数字
-b 1M 每个文件最大1M
tomcat-bankgw-app.log.10 child     需要切割的文件是tomcat-bankgw-app.log.10，生成的子文件前缀是 "child"

案例：
[hadoop@fdc08 testSplit]$ split -a 2 -d -b 22188 out.txt child     
[hadoop@fdc08 testSplit]$ ll
total 92
-rw-rw-r-- 1 hadoop hadoop 22188 Jun  9 17:13 child00
-rw-rw-r-- 1 hadoop hadoop 22187 Jun  9 17:13 child01
-rw-rw-r-- 1 hadoop hadoop 44375 Jun  9 17:12 out.txt
```

