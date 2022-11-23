# Hologres时间和日期函数

## 1- 获取当前时间

``` sql
-- 获取 年-月-日
select current_date;			--# timestamp : 2022-02-17

-- 获取 时:分:秒
select current_time ;			--# timestamp : 13:53:26

-- 获取 年-月-日 时:分:秒
select current_timestamp ;		--# timestamp : 2022-02-17 13:53:19
select transaction_timestamp();	--# timestamp : 2022-02-17 13:53:12
select localtimestamp;			--# timestamp : 2022-02-17 13:53:04
select now();					--# timestamp : 2022-02-17 13:52:52
select clock_timestamp();		--# timestamp : 2022-02-17 13:52:40
select statement_timestamp();	--# timestamp : 2022-02-17 13:52:25

-- 获取 当前实际时间 文本字符串格式
select timeofday();				--# text : Thu Feb 17 13:46:25.345013 2022 CST
```



## 2- 获取日期

``` sql
select date('2022-02-16 00:22:23');	--# date 2022-02-16
select date('2022-02-17');			--# date 2022-02-17
select current_date;				--# date 2022-02-17
```



## 3- timestamp 时间戳转日期

``` sql
select to_timestamp(1645077789); 		--# timestamp : 2022-02-17 14:03:09
select to_timestamp(1645077789534/1000);--# timestamp : 2022-02-17 14:03:09 
```



## 4- 将时间戳转换为字符串

``` sql
select to_timestamp(1645077789)::text; 				--# text : 2022-02-17 14:03:09+08
select to_char(now(),'HH12:MI:SS');					--# text : 02:37:17
select to_char(current_timestamp ,'HH24:MI:SS');	--# text : 14:37:27
```



## 5- 日期的减法运算

``` sql
select date('2022-02-10')-date('2022-02-01');		--# int8 : 9
```



## 6- 从时间戳中获取子 字段

``` sql
select date_part('year', now());
select date_part('month', current_timestamp);
select date_part('day', localtimestamp);
select date_part('hour', clock_timestamp());
select date_part('Minute', to_timestamp(1645077789));

select extract('year' from now());
select extract('month' from current_timestamp);
select extract('day' from  localtimestamp);
select extract('hour' from  clock_timestamp());
select extract('Minute' from  to_timestamp(1645077789));
```



## 7- 截断时间戳到指定 精度

``` sql
select date_trunc('year', now());
select date_trunc('month', current_timestamp);
select date_trunc('day', localtimestamp);
select date_trunc('hour', clock_timestamp());
select date_trunc('Minute', to_timestamp(1645077789));
```

