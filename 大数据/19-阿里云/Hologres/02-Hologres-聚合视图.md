# 1- 使用限制

- 在使用聚合视图功能之前，需要**Superuser在DB**内执行以下语句安装扩展包才可以使用聚合视图。一个DB只需执行一次即可，如果创建新的DB，还需要再次执行如下语句。

``` sql
create extension  aggregate_view;
```





# 2- 创建聚合视图

## 2-1 语法  -- hg_aggregate_view_create

``` sql
call hg_aggregate_view_create(
    aggregate_dst_view ,--目标view名
    aggregate_src_table ,--待聚合表名
    aggregate_keys_non_time ,--非时间粒度待聚合key
    aggregate_key_time , --时间粒度聚合key
    aggregate_values ,--待聚合的列名。按照顺序排列，不可重复
    aggregate_funcs ,--聚合函数，支持sum,min,max,count,avg,approx_count_distinct
    aggregate_timestamp_column ,--刷新时间列，精确时间列，类型须是timestamptz
    aggregate_allowed_lateness ,--允许晚到时间
    aggregate_base_table_ttl --聚合数据保存时间 second
);
```

## 2-2 参数说明

| 参数                       | 类型     | 说明                                                         |
| :------------------------- | :------- | :----------------------------------------------------------- |
| aggregate_dst_view         | text     | 目标View名。                                                 |
| aggregate_src_table        | text     | 待聚合表名。                                                 |
| aggregate_keys_non_time    | text[]   | 非时间粒度待聚合key。                                        |
| aggregate_key_time         | text     | 时间粒度待聚合key。时间维度，查询时展示的时间维度，同时也是查询指定的时间范围。 |
| aggregate_values           | text[]   | 待聚合的列名。按照顺序排列，不可重复。                       |
| aggregate_funcs            | text[]   | 聚合函数。支持的聚合函数具体如下：<br><font color='red'>sum</font>：求和函数。<br/><font color='red'>min</font>：最小值函数。<br/><font color='red'>max</font>：最大值函数。<br/><font color='red'>count</font>：计数函数。<br/><font color='red'>avg</font>：平均值函数。<br/><font color='red'>approx_count_distinct</font>：计算某一列去重后的行数，但为近似值，结果为二进制类型，需调用approx_count_distinct_final返回数值，支持使用approx_count_distinct_merge聚合。<br/><font color='red'>**rb_count_distinct**</font>：计算某一列去重后行数值，只支持int32类型，结果为二进制类型，需调用rb_cardinality返回数值，支持用rb_or_agg聚合，<font color='orange'>使用前需要创建roaringbitmap extention</font>。如下所示：` create extension roaringbitmap_hqe;` |
| aggregate_timestamp_column | text     | 精确时间列，按照该列定时刷新。这一列在源表中必须非空。       |
| aggregate_allowed_lateness | interval | 允许数据晚到的时间，数据最晚刷新的时间不超过该时间。需要和精确时间搭配使用，当不指定截止时间调用refresh时，用源表max(aggregate_timestamp_column)-aggregate_allowed_lateness做截止时间。 |
| aggregate_base_table_ttl   | int      | 聚合视图内数据保存的时间，单位为秒（s），超过该时间，数据将会被清除。 |



## 2-3 使用示例

本样例提供的样本数据具体如下：

| event_id | uid       | user_id | event_time          | province | city     | PV   | charge | event_count |
| :------- | :-------- | :------ | :------------------ | :------- | :------- | :--- | :----- | :---------- |
| 1002     | User10011 | 10011   | 2020-11-11 00:01:11 | hebei    | tangshan | 1    | 10     | 10          |
| 1002     | User10012 | 10012   | 2020-11-11 00:01:12 | shandong | qingdao  | 2    | 11     | 11          |
| 1003     | User10013 | 10013   | 2020-11-11 00:01:13 | hunan    | changsha | 2    | 11.9   | 11          |
| 1002     | User10012 | 10012   | 2020-11-11 00:01:14 | shandong | qingdao  | 1    | 1.1    | 9           |
| 1002     | User10012 | 10012   | 2020-11-11 00:01:14 | shandong | qingdao  | 1    | 1.1    | 9           |



### 2-3-1 对应数据创建步骤

#### 2-3-1-1 建表并插入样本数据	

``` sql
CREATE TABLE agg_src_table
(
    event_id INT
    ,user_id TEXT
    ,uid INT
    ,event_time timestamptz NOT NULL
    ,province TEXT
    ,city TEXT
    ,pv INT
    ,charge NUMERIC(15,2)
    ,event_count INT
);

insert into agg_src_table values 
(1002, 'User10011', 10011, '2020-11-11 00:01:11', 'hebei', 'tangshan', 1, 10,10 ),
(1002, 'User10012', 10012, '2020-11-11 00:01:12', 'shandong', 'qingdao', 2, 11,11 ),
(1003, 'User10013', 10013, '2020-11-11 00:01:13', 'hunan', 'changsha', 2, 11.9, 11 ),
(1002, 'User10012', 10012, '2020-11-11 00:01:14', 'shandong', 'qingdao', 1, 1.1, 9 ),
(1002, 'User10012', 10012, '2020-11-11 00:01:14', 'shandong', 'qingdao', 1, 1.1, 9 );
```

#### 2-3-1-2 创建一个view

- 将时间事件截取到小时粒度

``` sql
CREATE view agg_src_view AS
SELECT  province
        ,city
        ,event_time
        ,date_trunc('hour', event_time) AS event_date
        ,pv
        ,charge
        ,event_count
        ,user_id
        ,uid
FROM    agg_src_table ;
```

#### 2-3-1-3 创建聚合视图

``` sql
--创建聚合视图扩展
create extension  aggregate_view;

--创建聚合视图
call hg_aggregate_view_create(
  'agg_dst_view', --目标view名
  'agg_src_view', --待聚合的表名，此处以初步加工后的view代替
  ARRAY['province', 'city'], --按照省份province和城市city聚合
  'event_date', --按照事件时间粒度聚合
  ARRAY['event_count', 'charge', 'pv', 'user_id'], 
  ARRAY['count','avg', 'sum', 'approx_count_distinct'],--计算event_count列的count，charge列的avg，pv列的sum，user_id列的近似去重，
  'event_time', --按照该列进行定时刷新
  '600 sec', --允许数据晚到600s
  '2592000'--聚合数据保存时间
    );
    
 --查询视图
 SELECT * FROM agg_dst_view;
```



# 3- 刷新聚合视图

- 刷新聚合视图可以将实时写入的新数据更新到聚合视图中，主要包括<font color='red'>截止时间刷新和区间刷新</font>;
- <font color='orange'>同一时间同一个View，只可以有一个刷新任务</font>;

## 3-1 截止时间刷新

- 截止时间刷新可以将<font color='red'>指定的截止时间</font>数据刷新;
- 如果是增量刷新（默认），**上次**截止时间到**本次**截止时间的数据会被刷新;
- 如果是全量刷新，截止时间之前的数据都会被刷新;

### 3-1-1 语法

``` sql
call hg_aggregate_view_refresh('aggregate_dst_view', 'refresh_until_timestamp','delta');
```

### 3-1-2 参数说明

| 参数                    | 类型        | 说明                                                         |
| :---------------------- | :---------- | :----------------------------------------------------------- |
| aggregate_dst_view      | text        | 目标View名。                                                 |
| refresh_until_timestamp | timestamptz | 刷新截止时间戳。aggregate_timestamp_column小于此值的记录都会被聚合写入basetable。缺省情况下refresh_until_timestamp取max(aggregate_timestamp_column)-aggregate_allowed_lateness的值。 |
| delta                   | bool        | 是否增量更新。<br>**true**：默认为true，增量更新，上次截止时间到这次截止时间的数据会被刷新。**false**：全量刷新，截止时间之前的数据都会被刷新，会将basetable中的数据清空再写入。 |



### 3-1-3 使用示例

#### 3-1-3-1 插入新的数据

``` sql
--插入新的数据
insert into agg_src_table values 
(1002, 'User10998', 10320, '2020-11-11 00:01:15', 'sichuan', 'chengdu', 2, 3,1 ),
(1003, 'User10007', 10343, '2020-11-12 00:01:15', 'zhejiang', 'hangzhou', 7, 2,4 ),
(1003, 'User10073', 10221, '2020-11-12 00:01:16', 'anhui', 'huangshan', 3, 8,4 );

```

#### 3-1-3-2 增量刷新

``` sql
--增量刷新
call hg_aggregate_view_refresh('agg_dst_view', '2020-11-11 01:00:00'::timestamptz,'true');

```



#### 3-1-3-3 全量刷新

``` sql
--全量刷新
call hg_aggregate_view_refresh('agg_dst_view', '2020-11-11 00:00:00'::timestamptz,'false');
```



## 3-2 区间刷新

- 区间刷新可以将**<font color='red'>指定某个时间区间内的数据更新</font>**到聚合视图中

### 3-2-1 语法

``` sql
call hg_aggregate_view_range_refresh('aggregate_dst_view','refresh_start_timestamp','refresh_until_timestamp');   
```

### 3-2-2 参数说明

| 参数                    | 类型        | 说明             |
| :---------------------- | :---------- | :--------------- |
| aggregate_dst_view      | text        | 目标View名。     |
| refresh_until_timestamp | timestamptz | 刷新截止时间戳。 |
| refresh_start_timestamp | timestamptz | 刷新开始时间戳。 |



### 3-2-3 使用示例

- 指定将2020-11-11 01:00:00到2020-11-12 01:00:00期间写入的数据进行刷新

``` sql
--刷新截止到(当前时间-允许晚到区间)
call hg_aggregate_view_range_refresh('agg_dst_view','2020-11-11 01:00:00'::timestamptz,'2020-11-12 01:00:00'::timestamptz);
```



# 4- 删除聚合视图

## 4-1 语法示例

```java
call hg_aggregate_view_delete('aggregate_dst_view');   
```

## 4-2 参数说明

- aggregate_dst_view：表示需要删除的聚合视图名。

## 4-3 使用示例

- 将删除名称为agg_dst_view的聚合视图。

```java
call hg_aggregate_view_delete('agg_dst_view');
```



# 5- 使用示例

- 本次示例以某网站访问数据为例，通过聚合视图定期计算；

- 对用户ID做近似去重和精确去重；
- 计算事件类型event_count的访问量；
- 平均收费情况（charge列的avg）；
- 总PV（pv列的sum）；
- 该聚合视图通过事件时间event_time列刷新；
- 累计600秒之前的汇聚结果；
- 视图的数据保存2592000秒；
- 过期将会被删除。



## 5-1 建表并插入样本数据

``` sql
CREATE TABLE agg_src_table
(
    event_id INT
    ,user_id TEXT
    ,uid INT
    ,event_time timestamptz NOT NULL
    ,province TEXT
    ,city TEXT
    ,pv INT
    ,charge NUMERIC(15,2)
    ,event_count INT
);

insert into agg_src_table values 
(1002, 'User10011', 10011, '2020-11-11 00:01:11', 'hebei', 'tangshan', 1, 10,10 ),
(1002, 'User10012', 10012, '2020-11-11 00:01:12', 'shandong', 'qingdao', 2, 11,11 ),
(1003, 'User10013', 10013, '2020-11-11 00:01:13', 'hunan', 'changsha', 2, 11.9, 11 ),
(1002, 'User10012', 10012, '2020-11-11 00:01:14', 'shandong', 'qingdao', 1, 1.1, 9 ),
(1002, 'User10012', 10012, '2020-11-11 00:01:14', 'shandong', 'qingdao', 1, 1.1, 9 );
                        
```

## 5-2 创建一个view

- 表初步加工，主要是创建一个view并将时间事件截取到小时粒度

``` sql
CREATE view agg_src_view AS
SELECT  province
        ,city
        ,event_time
        ,date_trunc('hour', event_time) AS event_date
        ,pv
        ,charge
        ,event_count
        ,user_id
        ,uid
FROM    agg_src_table ;
```



## 5-3 创建聚合视图

- 对用户ID精确去重，需要开启RoaringBitmap扩展使用rb_count_distinct函数。更多关于RoaringBitmap函数的说明，请参见[Roaring Bitmap函数](https://help.aliyun.com/document_detail/216945.htm#concept-2069643)

``` sql
--创建聚合视图扩展
create extension  aggregate_view;
--创建Roaringbitmap扩展
create extension  roaringbitmap;

--创建聚合视图，在province，city维度聚合;
--基于event_date日期粒度;
--计算event_count列的count;
--charge列的avg;
--pv列的sum;
--user_id列的approx_count_distinct;
--uid列的rb_count_distinct算子;
--刷新时间戳为event_time列;
--累计600秒之前的汇聚结果;
--数据保存2592000秒;
call hg_aggregate_view_create(
  'agg_dst_view', 
  'agg_src_view', 
  ARRAY['province', 'city'], 
  'event_date', 
  ARRAY['event_count', 'charge', 'pv', 'user_id', 'uid'], 
  ARRAY['count','avg', 'sum', 'approx_count_distinct', 'rb_count_distinct'],
  'event_time', 
  '600 sec', 
  '2592000');
```



## 5-4 数据查询和插入处理

``` sql
--业务查询语句
SELECT  province
        ,city
        ,event_date
        ,event_count
        ,charge
        ,pv
        ,approx_count_distinct_final(user_id) AS user_id
        ,rb_cardinality(uid) AS uid
FROM    agg_dst_view
WHERE   event_date > '2020-11-01'::timestamptz
AND     event_date < '2020-11-12'::timestamptz;

--插入新的数据
insert into agg_src_table values 
(1002, 'User10998', 10320, '2020-11-11 00:01:15', 'sichuan', 'chengdu', 2, 3,1 ),
(1003, 'User10007', 10343, '2020-11-12 00:01:15', 'zhejiang', 'hangzhou', 7, 2,4 ),
(1003, 'User10073', 10221, '2020-11-12 00:01:16', 'anhui', 'huangshan', 3, 8,4 );

--刷新截止到(当前表最大时间-允许晚到区间)  '2020-11-12 00:01:16' - '600 sec' = '2020-11-11 23:51:16'
call hg_aggregate_view_refresh('agg_dst_view');

--刷新截止到2020-11-12 01:20:00之前的数据
call hg_aggregate_view_refresh('agg_dst_view', '2020-11-12 01:20:00'::timestamptz,'true');

--带有近似去重函数的查询语句
SELECT  city
        ,approx_count_distinct_final(approx_count_distinct_merge(user_id)) AS user_id
FROM    agg_dst_view
WHERE   event_date > '2020-11-11'::timestamptz
AND     event_date < '2020-11-13'::timestamptz
GROUP BY city;

--带有精确去重函数的查询语句
  SELECT  city
        ,SUM(pv)
        ,rb_cardinality(rb_or_agg(uid)) AS uid
FROM    agg_dst_view
WHERE   event_date > '2020-11-10'::timestamptz
AND     event_date < '2020-11-12'::timestamptz
GROUP BY city;

--再聚合查询
SELECT  province
        ,SUM(event_count)
        ,SUM(pv)
        ,approx_count_distinct_final(approx_count_distinct_merge(user_id)) AS user_id
        ,rb_cardinality(rb_or_agg(uid)) AS uid
FROM    agg_dst_view
WHERE   event_date > '2020-11-10'::timestamptz
AND     event_date < '2020-11-15'::timestamptz
GROUP BY province;
```

## 5-5 删除聚合视图

``` sql
--删除聚合视图
call hg_aggregate_view_delete('agg_dst_view');
```







