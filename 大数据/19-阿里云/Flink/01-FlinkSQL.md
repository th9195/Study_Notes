# 1- kafka 作为源

``` properties
CREATE TABLE ali_kafka_table (
  stu_id String,
  stu_name String,
  stu_gender String,
  `topic` STRING METADATA VIRTUAL,
  `partition` BIGINT METADATA VIRTUAL
) WITH (
  'connector' = 'kafka',
  'topic' = 'flink_test',
  'properties.bootstrap.servers' = '10.10.45.167:9092,10.10.45.165:9092,10.10.45.166:9092',  -- kafka集群
  'properties.group.id' = 'flink-test',
  'format' = 'json',   -- 格式为json
  'scan.startup.mode' = 'latest-offset',   --group-offsets
  'json.ignore-parse-errors' = 'true'    -- 解析出错不退出
)
```

