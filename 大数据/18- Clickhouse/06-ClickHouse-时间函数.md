# 1- Clickhouse 时间日期函数

## 1-1 常用时间函数

``` properties
now()                // 2020-04-01 17:25:40     取当前时间
toYear()             // 2020                    取日期中的年份
toMonth()            // 4                       取日期中的月份
today()              // 2020-04-01              今天的日期
yesterday()          // 2020-03-31              昨天的额日期
toDayOfYear()        // 92                      取一年中的第几天     
toDayOfWeek()        // 3                       取一周中的第几天
toHour()             //17                       取小时
toMinute()           //25                       取分钟
toSecond()           //40                       取秒
toStartOfYear()      //2020-01-01               取一年中的第一天
toStartOfMonth()     //2020-04-01               取当月的第一天
 
formatDateTime(now(),'%Y-%m-%d')        // 2020*04-01         指定时间格式
toYYYYMM()                              //202004              
toYYYYMMDD()                            //20200401
toYYYYMMDDhhmmss()                      //20200401172540
dateDiff()
......
```

- 案例

```sql
SELECT
    toDateTime('2021-10-19 10:10:10') AS time,  
   
    -- 将DateTime转换成Unix时间戳
    toUnixTimestamp(time) as unixTimestamp,  
      
    -- 保留 时-分-秒
    toDate(time) as date_local,
    toTime(time) as date_time,   -- 将DateTime中的日期转换为一个固定的日期，同时保留时间部分。
 
    -- 获取年份，月份，季度，小时，分钟，秒钟
    toYear(time) as get_year,
    toMonth(time) as get_month,
 
    -- 一年分为四个季度。1（一季度:1-3）,2（二季度:4-6）,3（三季度:7-9）,4（四季度:10-12）
    toQuarter(time) as get_quarter,
    toHour(time) as get_hour,
    toMinute(time) as get_minute,
    toSecond(time) as get_second,
 
    -- 获取 DateTime中的当前日期是当前年份的第几天，当前月份的第几日，当前星期的周几
    toDayOfYear(time) as "当前年份中的第几天",
    toDayOfMonth(time) as "当前月份的第几天",
    toDayOfWeek(time) as "星期",
    toDate(time, 'Asia/Shanghai') AS date_shanghai,
    toDateTime(time, 'Asia/Shanghai') AS time_shanghai,
 
    -- 得到当前年份的第一天,当前月份的第一天，当前季度的第一天，当前日期的开始时刻
    toStartOfYear(time),
    toStartOfMonth(time),
    toStartOfQuarter(time),
    toStartOfDay(time) AS cur_start_daytime,
    toStartOfHour(time) as cur_start_hour,
    toStartOfMinute(time) AS cur_start_minute,
 
    -- 从过去的某个固定的时间开始，以此得到当前指定的日期的编号
    toRelativeYearNum(time),
    toRelativeQuarterNum(time);
```



## 1-2 获取未来时间的函数

``` sql
-- 第一种，日期格式（指定日期，需注意时区的问题）
WITH
    toDate('2019-09-09') AS date,
    toDateTime('2019-09-09 00:00:00') AS date_time
SELECT
    addYears(date, 1) AS add_years_with_date,
    addYears(date_time, 0) AS add_years_with_date_time;
 
-- 第二种，日期格式（当前，本地时间）
WITH
    toDate(now()) as date,
    toDateTime(now()) as date_time
SELECT
    now() as now_time,-- 当前时间
    -- 之后1年
    addYears(date, 1) AS add_years_with_date,                  
    addYears(date_time, 1) AS add_years_with_date_time,
    
    -- 之后1月
    addMonths(date, 1) AS add_months_with_date,                 
    addMonths(date_time, 1) AS add_months_with_date_time,
 
    -- 之后1周
    addWeeks(date, 1) AS add_weeks_with_date,                   
    addWeeks(date_time, 1) AS add_weeks_with_date_time,
 
    -- 之后1天
    addDays(date, 1) AS add_days_with_date,                     
    addDays(date_time, 1) AS add_days_with_date_time,
 
    -- 之后1小时
    addHours(date_time, 1) AS add_hours_with_date_time,  
    
    -- 之后1分中       
    addMinutes(date_time, 1) AS add_minutes_with_date_time,
 
    -- 之后10秒钟     
    addSeconds(date_time, 10) AS add_seconds_with_date_time,
    
     -- 之后1个季度    
    addQuarters(date, 1) AS add_quarters_with_date,            
    addQuarters(date_time, 1) AS add_quarters_with_date_time;
```



## 1-3 获取过去时间的函数

``` sql
WITH
    toDate(now()) as date,
    toDateTime(now()) as date_time
SELECT
	-- 年
    subtractYears(date, 1) AS subtract_years_with_date,
    subtractYears(date_time, 1) AS subtract_years_with_date_time,

	-- 季度
    subtractQuarters(date, 1) AS subtract_Quarters_with_date,
    subtractQuarters(date_time, 1) AS subtract_Quarters_with_date_time,
    
    -- 月
    subtractMonths(date, 1) AS subtract_Months_with_date,
    subtractMonths(date_time, 1) AS subtract_Months_with_date_time,
    
    -- 周
    subtractWeeks(date, 1) AS subtract_Weeks_with_date,
    subtractWeeks(date_time, 1) AS subtract_Weeks_with_date_time,
    
    -- 日
    subtractDays(date, 1) AS subtract_Days_with_date,
    subtractDays(date_time, 1) AS subtract_Days_with_date_time,
    
    -- 小时
    subtractHours(date_time, 1) AS subtract_Hours_with_date_time,
    
    -- 分组
    subtractMinutes(date_time, 1) AS subtract_Minutes_with_date_time,
    
    -- 秒
    subtractSeconds(date_time, 1) AS subtract_Seconds_with_date_time;
 
SELECT toDate('2019-07-31', 'Asia/GuangZhou') as date_guangzhou;
SELECT toDate('2019-07-31'), toDate('2019-07-31', 'Asia/Beijing') as date_beijing;
 
-- 亚洲只能加载上海的timezone？？？
SELECT toDateTime('2019-07-31 10:10:10', 'Asia/Shanghai') as date_shanghai;
```



## 1-4 计算连个时刻在不同时间单位下的差值

``` sql
-- 第一种：指定时间计算差值示例
WITH
    toDateTime('2020-10-31 11:20:30', 'Asia/Shanghai') as date_shanghai_one,
    toDateTime('2021-11-11 11:20:30', 'Asia/Shanghai') as date_shanghai_two
SELECT
    dateDiff('year', date_shanghai_one, date_shanghai_two) as diff_years,
    dateDiff('month', date_shanghai_one, date_shanghai_two) as diff_months,
    dateDiff('week', date_shanghai_one, date_shanghai_two) as diff_week,
    dateDiff('day', date_shanghai_one, date_shanghai_two) as diff_days,
    dateDiff('hour', date_shanghai_one, date_shanghai_two) as diff_hours,
    dateDiff('minute', date_shanghai_one, date_shanghai_two) as diff_minutes,
    dateDiff('second', date_shanghai_one, date_shanghai_two) as diff_seconds;
 
-- 第二种：本地当前时间示例
WITH
    now() as date_time
SELECT
    dateDiff('year', date_time, addYears(date_time, 1)) as diff_years,
    dateDiff('month', date_time, addMonths(date_time, 2)) as diff_months,
    dateDiff('week', date_time, addWeeks(date_time, 3)) as diff_week,
    dateDiff('day', date_time, addDays(date_time, 3)) as diff_days,
    dateDiff('hour', date_time, addHours(date_time, 3)) as diff_hours,
    dateDiff('minute', date_time, addMinutes(date_time, 30)) as diff_minutes,
    dateDiff('second', date_time, addSeconds(date_time, 35)) as diff_seconds;
```

