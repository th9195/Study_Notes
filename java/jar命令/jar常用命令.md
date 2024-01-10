## 1- 查看jar包中是否有某个class文件

- jar tvf 

```shell
[hadoopadmin@fdc01 ]$ jar tvf VmcAllFlinkJob-231208005658.jar  | grep -i VmcAllApplication
  1083 Fri Dec 08 00:57:24 CST 2023 com/hzw/application/VmcAllApplication$$anonfun$1.class
  4485 Fri Dec 08 00:57:24 CST 2023 com/hzw/application/VmcAllApplication$.class
   957 Fri Dec 08 00:57:24 CST 2023 com/hzw/application/VmcAllApplication$delayedInit$body.class
  1339 Fri Dec 08 00:57:24 CST 2023 com/hzw/application/VmcAllApplication.class
[hadoopadmin@fdc01 ]$ 


```

