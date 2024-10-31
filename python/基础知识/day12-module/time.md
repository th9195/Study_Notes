```python

import time

# 获取时间戳
ticks = time.time()
print('ticks == %s'%(ticks))
# ticks == 1727591792.7660272

# 获取纳秒级别的时间戳
ns = time.time_ns()
print('ns == %s'%(ns))
# ns == 1727591792766027200


# 获取当前时间信息
localtime = time.localtime()
print('localtime == ',localtime)
print('year == ' , localtime.tm_year)
print('tm_mon == ' , localtime.tm_mon)
print('tm_mday == ' , localtime.tm_mday)

print('tm_wday == ' , localtime.tm_wday)
print('tm_yday == ' , localtime.tm_yday)
print('tm_isdst == ' , localtime.tm_isdst)
print('tm_zone == ' , localtime.tm_zone)
print('tm_gmtoff == ' , localtime.tm_gmtoff)

print('tm_hour == ' , localtime.tm_hour)
print('tm_min == ' , localtime.tm_min)
print('tm_hour == ' , localtime.tm_hour)
print('tm_sec == ' , localtime.tm_sec)


##### 获取格式化的时间
asctime = time.asctime( time.localtime(time.time()) )
print("本地时间为 :", asctime)



### 格式化日期
# 格式化成2016-03-20 11:45:39形式
print(time.strftime("%Y-%m-%d %H:%M:%S", localtime))

# 格式化成Sat Mar 28 22:24:24 2016形式
print(time.strftime("%a %b %d %H:%M:%S %Y", localtime))


# 将格式字符串转换为时间戳
a = "Sat Mar 28 22:24:24 2016"
print(time.mktime(time.strptime(a, "%a %b %d %H:%M:%S %Y")))


'''
python中时间日期格式化符号：

%y 两位数的年份表示（00-99）
%Y 四位数的年份表示（000-9999）
%m 月份（01-12）
%d 月内中的一天（0-31）
%H 24小时制小时数（0-23）
%I 12小时制小时数（01-12）
%M 分钟数（00-59）
%S 秒（00-59）
%a 本地简化星期名称
%A 本地完整星期名称
%b 本地简化的月份名称
%B 本地完整的月份名称
%c 本地相应的日期表示和时间表示
%j 年内的一天（001-366）
%p 本地A.M.或P.M.的等价符
%U 一年中的星期数（00-53）星期天为星期的开始
%w 星期（0-6），星期天为星期的开始
%W 一年中的星期数（00-53）星期一为星期的开始
%x 本地相应的日期表示
%X 本地相应的时间表示
%Z 当前时区的名称
%% %号本身
'''



```

