## 1- 匹配删除key 

- 根据前缀删除key

```shell
./redis-cli -p 6679 keys "advancedIndicator_drift*" | xargs ./redis-cli  -p 6679 del
```



# 2- 查redis数据输出到文件

```shell
./redis-cli -h 127.0.0.1 -p 6379 -n 2 get "controlPlanConfig|1027"  >> /home/re.log
```



