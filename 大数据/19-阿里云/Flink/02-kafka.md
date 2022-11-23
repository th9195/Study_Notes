# 1- 阿里云kafka

地址：https://kafka.console.aliyun.com/region/cn-beijing/instances

接入点: 10.10.45.167:9092,   10.10.45.165:9092,   10.10.45.166:9092



## 1-1 模拟生成数据

``` properties
G:\kafka_2.11-2.0.0\kafka_2.11-2.0.0\bin\windows> .\kafka-console-producer.bat --broker-list 10.10.45.167:9092,10.10.45.165:9092,10.10.45.166:9092 --topic flink_test
```

- 案例

``` json
{"stu_id":"1","stu_name":"Tom1","stu_gender":"female"}


{[{"stu_id":"1","stu_name":"Tom1","stu_gender":"male"},{"stu_id":"2","stu_name":"Tom2","stu_gender":"female"}]}

```



## 1-2 模拟消费数据

``` properties
kafka-console-consumer --bootstrap-server bigdata-test01:9092 --topic test01 --from-beginning
```





