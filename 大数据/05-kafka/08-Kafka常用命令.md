# 1- kafka 路径： 
/opt/cloudera/parcels/KAFKA/bin/kafka-console-consumer


# 2- 创建topic
/opt/cloudera/parcels/KAFKA/bin/kafka-topics  --create  --zookeeper fdc04:9092  --topic test01 --partitions 3  --replication-factor 3


# 3- 查看所有 topic
/opt/cloudera/parcels/KAFKA/bin/kafka-topics  --describe  --zookeeper fdc04:2181  --topic  mainfab_long_run_controlplan_config_topic

# 4- 查看所有的groupId

sh kafka-consumer-groups.sh --new-consumer --bootstrap-server 172.21.51.109:9092 --list 



# 5- **查看指定groupid的详细信息** 

sh kafka-consumer-groups.sh --new-consumer --bootstrap-server 172.21.51.109:9092 --group point_expire_group --describe 



# 4- 发送消息

bin/kafka-console-producer  --broker-list fdc04:9092 --topic first 
>hello world 
>hello kafka 



# 5- 实时消费数据
/opt/cloudera/parcels/KAFKA/bin/kafka-console-consumer --bootstrap-server fdc04:9092 --topic mainfab_data_topic  

/opt/cloudera/parcels/KAFKA/bin/kafka-console-consumer --bootstrap-server fdc04:9092 --topic mainfab_long_run_controlplan_config_topic

/opt/cloudera/parcels/KAFKA/bin/kafka-console-consumer --bootstrap-server fdc04:9092 --topic mainfab_long_run_window_config_topic

# 6- from-beginning 消费数据
bin/kafka-console-consumer.sh --bootstrap-server fdc04:9092 --from-beginning --topic first



# 7- 生产数据 指定文件
cat data.txt |  kafka-console-producer --broker-list 172.24.103.8:9092 --topic test_taos | > out.txt



/opt/cloudera/parcels/KAFKA/bin/kafka-console-producer --broker-list fdc12:9092 --topic test < out.txt




# 8- 查看文件行数
wc -l data.txt

# 9- 查看topic的offset
kafka-run-class kafka.tools.GetOffsetShell --broker-list 172.24.103.8:9092 --topic test_taos



# 10- 查看当前服务器中所有的topic
bin/kafka-topics.sh --zookeeper hadoop102:2181 --list



# 11- 查看消费者组消费的情况

/opt/cloudera/parcels/KAFKA/bin/kafka-consumer-groups --bootstrap-server fdc12:9092,fdc13:9092,fdc14:9092 --group  consumer-group-mainfab-write-raw-data-job --describe


