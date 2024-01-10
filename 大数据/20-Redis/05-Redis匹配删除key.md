## 1- 匹配删除key 

- 根据前缀删除key

```shell
./redis-cli -p 6679 keys "advancedIndicator_drift*" | xargs ./redis-cli  -p 6679 del
```

