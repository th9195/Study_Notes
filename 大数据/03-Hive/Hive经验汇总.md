

# 1- 通过身份证获取性别

```sql
select 
	substring(jkx_usercard,17,1) as sex, 
	cast( case 
		when jkx_usercard is null or length(jkx_usercard) < 18 then 3 
		when mod(cast(substring(jkx_usercard,17,1) as Int),2) = 0 then 2  # 偶数：女
		else 1  # 奇数：男
	end as TinyInt) as sex2 ,
	length(jkx_usercard) as leng  

	from hive.zhwdb.zhw_user  
where part_day = '2021-10-11' and pid != 0 ;
```

