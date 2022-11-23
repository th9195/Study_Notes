[TOC]



# 1- JSON和JSONB类型区别

- 存储格式
  - JSON类型储存的是**文本格式**的数据；
  - JSONB储存的是**BINARY格式**的数据

- 速度
  - JSON类型**插入**速度**快**，**查询**速度**慢**；
  - JSONB类型**插入**速度**慢**，**查询**速度**快**;



# 2- JSON 和 JSONB的操作符

| 操作符 | 功能描述                                                     | 右操作符类型 | 示例                                                         | 结果值                                           | 结果类型                      |
| ------ | ------------------------------------------------------------ | ------------ | ------------------------------------------------------------ | ------------------------------------------------ | ----------------------------- |
| ->     | 获得JSON**<font color='red'>数组</font>元素**（索引从<font color='red'>0</font>开始，负整数从末尾开始计） | int          | select '[{"name1":"Tom1"},{"name2":"Tom2"},{"name3":"Tom3"}]'::jsonb->2 | {"name3": "Tom3"}                                | json                          |
| ->     | 通过**<font color='red'>键</font>**获得JSON对象域            | text         | select '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb->'address' | "wuhan"                                          | json                          |
| ->>    | **text形式** 获得JSON**<font color='red'>数组</font>元素**（索引从<font color='red'>0</font>开始，负整数从末尾开始计） | int          | select '[{"name1":"Tom1"},{"name2":"Tom2"},{"name3":"Tom3"}]'::jsonb->2 | {"name3": "Tom3"}                                | <font color='red'>text</font> |
| ->>    | **text形式**通过**<font color='red'>键</font>**获得JSON对象中的值 | text         | select '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb->'address' | "wuhan"                                          | <font color='red'>text</font> |
| #>     | 获取在<font color='red'>**指定路径**</font>的JSON对象        | text[]       | select <br/>'{<br/>	"school1":{<br/>		"0801":{"name":"Tom8","age":20,"address":"wuhan"},<br/>		"0802":{"name":"Jerry8","age":30,"address":"北京"}<br/>	},<br/>	"school2":{<br/>		"0901":{"name":"Tom9","age":20,"address":"wuhan"},<br/>		"0902":{"name":"Jerry9","age":30,"address":"北京"}<br/>	}<br/>}'::jsonb#>'{school1,0802}'; | {"age": 30, "name": "Jerry8", "address": "北京"} | json                          |
| #>>    | **text形式**获取在**<font color='red'>指定路径</font>**的JSON对象 | text[]       | select <br/>'{<br/>	"school1":{<br/>		"0801":{"name":"Tom8","age":20,"address":"wuhan"},<br/>		"0802":{"name":"Jerry8","age":30,"address":"北京"}<br/>	},<br/>	"school2":{<br/>		"0901":{"name":"Tom9","age":20,"address":"wuhan"},<br/>		"0902":{"name":"Jerry9","age":30,"address":"北京"}<br/>	}<br/>}'::jsonb#>>'{school2,0901,name}'; | Tom9                                             | <font color='red'>text</font> |
|        |                                                              |              |                                                              |                                                  |                               |

# 3- <font color='red'>JSONB</font>额外的操作符

## 3-1 @> 判断左侧是否包含右侧

### 3-1-1 描述

- 左侧的JSON值是否<font color='red'>**在顶层**</font>  **<font color='red'>包含</font>**右侧的JSON路径或值？

### 3-1-2 右操作符类型

- jsonb

### 3-1-3 示例

``` sql
# false
select '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb @> '{"b":2}'::jsonb;

# true
select '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb @> '{"name":"Tom"}'::jsonb;

# 0
# 1
select 
	case 
		when '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb @> '{"b":2}'::jsonb then 1
		else 0
	end as is_b,
	case 
		when '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb @> '{"name":"Tom"}'::jsonb then 1
		else 0
	end as is_name;
```



### 3-1-4 结果值

- true or false

### 3-1-5 结果值类型

- Boolean



## 3-2 <@ 判断右侧是否包含左侧

### 3-2-1 描述

- 与@>相反
- 左侧的JSO 路径或值项是否**<font color='red'>被包含</font>**在右侧的JSON 值的**<font color='red'>顶层</font>**？

### 3-2-2 右操作符类型

- jsonb

### 3-2-3 示例

``` sql

--false
select  '{"b":2}'::jsonb   <@ '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb ;

-- true
select   '{"name":"Tom"}'::jsonb <@  '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb ;

-- 0
-- 1
select 
	case 
		when '{"b":2}'::jsonb   <@ '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb then 1
		else 0
	end as is_b,
	case 
		when '{"name":"Tom"}'::jsonb <@  '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb then 1
		else 0
	end as is_name;
```



### 3-2-4 结果值

- true or false

### 3-2-5 结果值类型

- Boolean



## 3-3 ? 是否在顶层

### 3-3-1 描述

- 键或元素字符串是否存在于JSON值的**<font color='red'>顶层</font>**？

### 3-3-2 右操作符类型

- text

### 3-3-3 示例

``` sql
-- true
select 
'{
	"school1":{
		"0801":{"name":"Tom8","age":20,"address":"wuhan"},
		"0802":{"name":"Jerry8","age":30,"address":"北京"}
	},
	"school2":{
		"0901":{"name":"Tom9","age":20,"address":"wuhan"},
		"0902":{"name":"Jerry9","age":30,"address":"北京"}
	}
}'::jsonb ? 'school1';

-- false
select 
'{
	"school1":{
		"0801":{"name":"Tom8","age":20,"address":"wuhan"},
		"0802":{"name":"Jerry8","age":30,"address":"北京"}
	},
	"school2":{
		"0901":{"name":"Tom9","age":20,"address":"wuhan"},
		"0902":{"name":"Jerry9","age":30,"address":"北京"}
	}
}'::jsonb ? 'name';


```



### 3-3-4 结果值

- true or false

### 3-3-5 结果值类型

- Boolean



## 3-4 ?|任意一个是否在顶层

### 3-4-1 描述

- **数组**字符串中的**<font color='red'>任何一个</font>**是否做为**<font color='red'>顶层</font>**键存在？

### 3-4-2 右操作符类型

- text[]

### 3-4-3 示例

``` sql
--true
select 
'{
	"school1":{
		"0801":{"name":"Tom8","age":20,"address":"wuhan"},
		"0802":{"name":"Jerry8","age":30,"address":"北京"}
	},
	"school2":{
		"0901":{"name":"Tom9","age":20,"address":"wuhan"},
		"0902":{"name":"Jerry9","age":30,"address":"北京"}
	}
}'::jsonb ?| array['school1','name'];

--false
select 
'{
	"school1":{
		"0801":{"name":"Tom8","age":20,"address":"wuhan"},
		"0802":{"name":"Jerry8","age":30,"address":"北京"}
	},
	"school2":{
		"0901":{"name":"Tom9","age":20,"address":"wuhan"},
		"0902":{"name":"Jerry9","age":30,"address":"北京"}
	}
}'::jsonb ?| array['age','name'];
```



### 3-4-4 结果值

- true or false

### 3-4-5 结果值类型

- Boolean



## 3-5 ?& 所有字段是否都在顶层

### 3-5-1 描述

- 是否**<font color='red'>所有</font>** **数组字符串**都作为**<font color='red'>顶层</font>**键存在？

### 3-5-2 右操作符类型

- text[]

### 3-5-3 示例

``` sql
-- true
select 
'{
	"school1":{
		"0801":{"name":"Tom8","age":20,"address":"wuhan"},
		"0802":{"name":"Jerry8","age":30,"address":"北京"}
	},
	"school2":{
		"0901":{"name":"Tom9","age":20,"address":"wuhan"},
		"0902":{"name":"Jerry9","age":30,"address":"北京"}
	}
}'::jsonb ?& array['school1','school2'];

-- false
select 
'{
	"school1":{
		"0801":{"name":"Tom8","age":20,"address":"wuhan"},
		"0802":{"name":"Jerry8","age":30,"address":"北京"}
	},
	"school2":{
		"0901":{"name":"Tom9","age":20,"address":"wuhan"},
		"0902":{"name":"Jerry9","age":30,"address":"北京"}
	}
}'::jsonb ?& array['school1','name'];
```



### 3-5-4 结果值

- true or false

### 3-5-5 结果值类型

- Boolean



## 3-6 || 两个jsonb拼接

### 3-6-1 描述

- 将两个jsonb值**<font color='red'>拼接</font>**成一个新的jsonb值

### 3-6-2 右操作符类型

- jsonb

### 3-6-3 示例

``` sql
select '{"name":"Tom1"}'::jsonb || '{"age":30}'::jsonb || '[1,2,3,4]'::jsonb
--[{"age": 30, "name": "Tom1"}, 1, 2, 3, 4]
```

### 3-6-4 结果值

- [{"age": 30, "name": "Tom1"}, 1, 2, 3, 4]

### 3-6-5 结果值类型

- jsonb



## 3-7 - 移除某个字段

### 3-7-1 描述

- 右操作符**<font color='red'>text</font>**:  从左操作数**<font color='red'>删除键/值对或者string元素</font>**。键/值对基于它们的键值来匹配。
- 右操作符**<font color='red'>text[]</font>**: 从左操作数中**<font color='red'>删除多个</font>**键/值对或者string元素。键/值对基于它们的键值来匹配。
- 右操作符**<font color='red'>int</font>**: 删除具有**<font color='red'>指定索引</font>**（从**<font color='red'>0开始</font>**，**负值表示倒数**）的**<font color='red'>数组</font>**元素。**如果顶层容器不是数组则抛出一个错误**。

### 3-7-2 右操作符类型

- text
- text[]
- int

### 3-7-3 示例

``` sql
--text
select '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb - 'name';
-- 结果:{"age": 30, "address": "wuhan"}

--text[]
select '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb - array['name','age2'];
--结果:{"address": "wuhan"}

--text[]   array中有一个key不存在
select '{"age": 30, "name": "Tom", "address": "wuhan"}'::jsonb - array['name','age2'];
--结果:{"age": 30, "address": "wuhan"}

--int
select '["name","age","address"]'::jsonb - 1;
--结果: ["name", "address"]
```



### 3-7-4 结果值

### 3-7-5 结果值类型

- jsonb



## 3-8 #- 指定路径移除

### 3-8-1 描述

- 删除具有**<font color='red'>指定路径</font>**的域或者元素（**对于JSON数组，负值表示倒数**）；

### 3-8-2 右操作符类型

- text[]

### 3-8-3 示例

``` sql
select 
'{
	"school1":{
		"0801":{"name":"Tom8","age":20,"address":"wuhan"},
		"0802":{"name":"Jerry8","age":30,"address":"北京"}
	},
	"school2":{
		"0901":{"name":"Tom9","age":20,"address":"wuhan"},
		"0902":{"name":"Jerry9","age":30,"address":"北京"}
	}
}'::jsonb #- array['school1','0801','age']

-- 结果:
{
	"school1":{
		"0801":{"name":"Tom8","address":"wuhan"},
		"0802":{"name":"Jerry8","age":30,"address":"北京"}
	},
	"school2":{
		"0901":{"name":"Tom9","age":20,"address":"wuhan"},
		"0902":{"name":"Jerry9","age":30,"address":"北京"}
	}
}

```



### 3-8-4 结果值

### 3-8-5 结果值类型

- json

# 4- JSON创建函数

## 4-1 array_to_json(anyarray [, pretty_bool]) 参数：array

### 4-1-1 功能描述

- 此函数可以将**数组**作为一个**JSON<font color='red'>数组</font>**返回
- 注意: <font color='red'>**只有 array_to_json 没有 array_to_jsonb**</font>

### 4-1-2 示例

``` sql
select array_to_json(array[1,2]) 
--结果:[1,2]

select array_to_json(array[array[1,2],array[3,4]])
--结果:[[1,2],[3,4]]

select array_to_json(array[array['name','age'],array['school','class']])
--结果:[["name","age"],["school","class"]]

```



### 4-1-3 结果类型

- json



## 4-2 json[b]_build_array 参数：可变

### 4-2-1 功能描述

- 此函数可以从一个**<font color='red'>可变参数列表</font>**构造一个可能包含**<font color='red'>多个类型</font>**的**<font color='red'>JSON数组</font>**

### 4-2-2 示例

``` sql
-- 创建json
select json_build_array(1,2,'3',4,5,1.4,1.5,array[1,2,3],array['name','age']);
--结果:[1, 2, "3", 4, 5, 1.4, 1.5, [1,2,3], ["name","age"]]

-- 取值
select json_build_array(1,2,'3',4,5,1.4,1.5,array[1,2,3],array['name','age'])->>5;
--结果:1.4
```



### 4-2-3 结果类型

- json or jsonb
- 数组



## 4-3  json[b]_build_object 参数：可变（偶数个）

### 4-3-1 功能描述

- 此函数可以从一个**<font color='red'>可变参数列表</font>**构造一个**<font color='red'>JSON对象</font>**;
- 通过转换，该参数列表由**交替出现的键和值**构成;
- 可变参数列表**长度**必须是**偶数**；

### 4-3-2 示例

``` sql
-- 偶数参数
select jsonb_build_object('name','Tom','age',30,'address','武汉','phone','159xxxx4250')
--结果:{"age": 30, "name": "Tom", "phone": "159xxxx4250", "address": "武汉"}

-- 奇数参数
select jsonb_build_object('name','Tom','age',30,'address','武汉','phone')
--结果:SQL 错误 [22023]: ERROR: argument list must have even number of elements
--Hint: The arguments of jsonb_build_object() must consist of alternating keys and values.

--取值
select jsonb_build_object('name','Tom','age',30,'address','武汉','phone','159xxxx4250')->'address'
--结果:"武汉"

```



### 4-3-3 结果类型

- json or jsonb



## 4-4  json[b]_object(text[]) 参数：text {偶数个}

### 4-4-1 功能描述

- 此函数可以从一个**<font color='red'>文本数组</font>**构造一个**<font color='red'>JSON对象</font>**;
- 该数组必须可以是具有**<font color='red'>偶数</font>**个成员的**<font color='red'>一维数组</font>**（成员被当做**交替出现的键/值对**）;
- 或者是一个**<font color='red'>二维数组</font>**（每一个内部数组刚好有2个元素，可以被看做是键/值对）。

### 4-4-2 示例

``` sql
-- 一维数组
select jsonb_object('{name, Tom,age, 30, address, 武汉}');
-- 结果:{"age": "30", "name": "Tom", "address": "武汉"}


-- 二维数组
select jsonb_object('{{name, Tom},{age, 30}, {address, 武汉}}');
-- 结果: {"age": "30", "name": "Tom", "address": "武汉"}
```



### 4-4-3 结果类型

- json or jsonb



## 4-5 json[b]_object(keys text[], values text[])

### 4-5-1 功能描述

- json_object的这种形式从**<font color='red'>两个独立的数组得到键/值对</font>**;

### 4-5-2 示例

``` sql
-- 不加引号 加引号 都可以
select json_object('{name, age,address}', '{Tom,30,武汉}');
-- 结果: {"name" : "Tom", "age" : "30", "address" : "武汉"}
```



### 4-5-3 结果类型

- json or jsonb



# 5- JSON和JSONB处理函数

## 5-1 jsonb_array_length(jsonb)

### 5-1-1 功能描述

- 返回最**<font color='red'>外层JSON数组</font>**中的元素**数量**。

### 5-1-2 参数类型

- json or jsonb
- text(json格式)

### 5-1-3 示例

``` sql
select jsonb_array_length('[1,2,3,{"f1":1,"f2":[5,6]},4]'::jsonb);
select jsonb_array_length('[1,2,3,{"f1":1,"f2":[5,6]},4]');
-- 结果: 5
```

### 5-1-4 返回值类型

- int



## 5-2 jsonb_object_keys(jsonb)

### 5-2-1 功能描述

- 返回最**<font color='red'>外层JSON对象</font>**中的**键**集合;

### 5-2-2 参数类型

- json or jsonb
- text(json格式)

### 5-2-3 示例

``` sql
select jsonb_object_keys('{
	"school1":{
		"0801":{"name":"Tom8","age":20,"address":"wuhan"},
		"0802":{"name":"Jerry8","age":30,"address":"北京"}
	},
	"school2":{
		"0901":{"name":"Tom9","age":20,"address":"wuhan"},
		"0902":{"name":"Jerry9","age":30,"address":"北京"}
	}
}'::jsonb); 

-- 结果:
school1
school2
```



### 5-2-4 返回值类型

- text



## 5-3 jsonb_array_elements(jsonb) ：<font color='red'>行转列</font>

### 5-3-1 功能描述

- 把一个**<font color='red'>JSON数组</font>** 中的外层扩展成一个**JSON**值的集合。

### 5-3-2 参数类型

- json or jsonb
- text(json格式)

### 5-3-3 示例

``` sql
select * from jsonb_array_elements('[1,true,"name", [2,false],"age"]');
select * from jsonb_array_elements('[1,true,"name", [2,false],"age"]'::jsonb);
--结果:
1
true
"name"
[2, false]
"age"
```



### 5-3-4 返回值类型

- json or jsonb



## 5-4 jsonb_array_elements_text(jsonb) <font color='red'>行转列</font>

### 5-4-1 功能描述

- 把一个**<font color='red'>JSON数组</font>** 外层扩展成一个**text**值集合。

### 5-4-2 参数类型

- json or jsonb
- text(json格式)

### 5-4-3 示例

``` sql

select * from jsonb_array_elements_text('[1,true,"name", [2,false],"age"]');
select * from jsonb_array_elements_text('[1,true,"name", [2,false],"age"]'::jsonb);
-- 结果:
1
true
name
[2, false]
age

```



### 5-4-4 返回值类型

- text



## 5-5 jsonb_typeof(jsonb)

### 5-5-1 功能描述

- 把最外层的JSON值的类型作为一个文本字符串返回。可能的类型是： object、array、string、number、 boolean以及null。

### 5-5-2 参数类型

### 5-5-3 示例

``` sql

select json_typeof('-123.4');
--结果: number

select json_typeof('"name"');
--结果: String

select json_typeof('true');
select json_typeof('false');
--结果: boolean

select json_typeof('null');
--结果: null

select jsonb_typeof('[1,true,"name", [2,false],"age"]'::jsonb);
--结果: array

select jsonb_typeof('{
	"school1":{
		"0801":{"name":"Tom8","age":20,"address":"wuhan"},
		"0802":{"name":"Jerry8","age":30,"address":"北京"}
	},
	"school2":{
		"0901":{"name":"Tom9","age":20,"address":"wuhan"},
		"0902":{"name":"Jerry9","age":30,"address":"北京"}
	}
}'::jsonb);
--结果: object
```



### 5-5-4 返回值类型

- text





# 6- JSONB的索引

- 从Hologres **<font color='red'>V1.1</font>**版本开始，支持JSONB索引
- 三种方式的**区别**为：
- **<font color='red'>jsonb_ops</font>**的GIN索引中，JSONB数据中的每个key和value都是作为一个单独的索引项的；
- **<font color='red'>jsonb_path_ops</font>**则只为每个value创建一个索引项；
- **<font color='red'>jsonb_holo_path_ops</font>**为Hologres全新的操作符号，可以省去检索数据后**recheck的动作**。

## 6-1 **<font color='red'>jsonb_ops</font>**

### 6-1-1 语法

``` sql
CREATE INDEX idx_name ON table_name USING gin (idx_col);
```

### 6-1-2 示例

#### 6-1-2-1 创建表的SQL语句

``` sql
CREATE TABLE IF NOT EXISTS json_table 
(
    id INT
    ,j jsonb
);
```



#### 6-1-2-2 创建**jsonb_ops**操作符号索引的SQL语句

``` sql
CREATE INDEX index_json on json_table USING GIN(j);
```



#### 6-1-2-3 在表中插入数据的SQL语句

``` sql
INSERT INTO json_table VALUES
(1, '{"key1": 1, "key2": [1, 2], "key3": {"a": "b"}}') ,
(1, '{"key1": 1, "key2": [1, 2], "key3": {"a": "b"}}') ;
```



#### 6-1-2-4 筛选包含数据的SQL语句

``` sql
SELECT  *
FROM    json_table
WHERE   j ? 'key1'
```



#### 6-1-2-5 执行结果

``` properties
 id |                        j                        
----+-------------------------------------------------
  1 | {"key1": 1, "key2": [1, 2], "key3": {"a": "b"}}
  1 | "key1"
(2 rows)
```



#### 6-1-2-6 使用`explain`命令查看执行计划

``` properties
                                       QUERY PLAN                                         
-------------------------------------------------------------------------------------------
 Gather  (cost=0.00..3.17 rows=1 width=43)
   ->  Exchange (Gather Exchange)  (cost=0.00..3.17 rows=1 width=43)
         ->  Decode  (cost=0.00..3.17 rows=1 width=43)
               ->  Bitmap Heap Scan on json_table  (cost=0.00..3.07 rows=1 width=43)
                     Recheck Cond: (j ? 'key1'::text)
                     ->  Bitmap Index Scan on index_json  (cost=0.00..0.00 rows=0 width=0)
                           Index Cond: (j ? 'key1'::text)
 Optimizer: HQO version 0.10.0
(8 rows)
```





## 6-2 **<font color='red'>jsonb_path_ops</font>**

### 6-2-1 语法

``` sql
CREATE INDEX idx_name ON table_name USING gin (idx_col jsonb_path_ops);
```

### 6-2-2 示例

#### 6-2-2-1 创建表的SQL语句

``` sql
CREATE TABLE IF NOT EXISTS json_table 
(
    id INT
    ,j jsonb
);
```



#### 6-2-2-2 创建jsonb_path_ops操作符号索引的SQL语句

``` sql
CREATE INDEX index_json on json_table USING GIN(j jsonb_path_ops);
```



#### 6-2-2-3 在表中插入数据的SQL语句

``` sql
INSERT INTO json_table (
    SELECT 
        i, 
        ('{
            "key1": "'||i||'"
            ,"key2": "'||i%100||'"
            ,"key3": "'||i%1000 ||'"
            ,"key4": "'||i%10000||'"
            ,"key5": "'||i%100000||'"
        }')::jsonb 
    FROM generate_series(1, 1000000) i
) ;
```



#### 6-2-2-4 筛选包含数据的SQL语句

``` sql
SELECT  *
FROM    json_table
WHERE   j @> '{"key1": "10"}'::JSONB 
```



#### 6-2-2-5 执行结果

``` properties
 id |                                   j                                    
----+------------------------------------------------------------------------
 10 | {"key1": "10", "key2": "10", "key3": "10", "key4": "10", "key5": "10"}
(1 row)
```



#### 6-2-2-6 使用`explain`命令查看执行计划

``` properties
                                           QUERY PLAN                                            
-------------------------------------------------------------------------------------------------
 Gather  (cost=0.00..34709320.40 rows=400000 width=88)
   ->  Exchange (Gather Exchange)  (cost=0.00..34709240.95 rows=400000 width=88)
         ->  Decode  (cost=0.00..34709240.92 rows=400000 width=88)
               ->  Bitmap Heap Scan on json_table  (cost=0.00..34709240.00 rows=400000 width=88)
                     Recheck Cond: (j @> '{"key1": "10"}'::jsonb)
                     ->  Bitmap Index Scan on index_json  (cost=0.00..0.00 rows=0 width=0)
                           Index Cond: (j @> '{"key1": "10"}'::jsonb)
 Optimizer: HQO version 0.10.0
(8 rows)
```



## 6-3 **<font color='red'>jsonb_holo_path_ops</font>**

### 6-3-1 语法

``` sql
CREATE INDEX idx_name ON table_name USING gin (idx_col jsonb_holo_path_ops);
```

### 6-3-2 示例

#### 6-3-2-1 创建表的SQL语句

``` sql
CREATE TABLE IF NOT EXISTS json_table 
(
    id INT
    ,j jsonb
);
```



#### 6-3-2-2 创建jsonb_holo_path_ops操作符号索引的SQL语句

``` sql
CREATE INDEX index_json on json_table USING GIN(j jsonb_holo_path_ops);
```



#### 6-3-2-3 在表中插入数据的SQL语句

``` sql
INSERT INTO json_table (
    SELECT 
        i, 
        ('{
            "key1": "'||i||'"
            ,"key2": "'||i%100||'"
            ,"key3": "'||i%1000 ||'"
            ,"key4": "'||i%10000||'"
            ,"key5": "'||i%100000||'"
        }')::jsonb 
    FROM generate_series(1, 1000000) i
) ;
```



#### 6-3-2-4 筛选包含数据的SQL语句

``` sql
SELECT  *
FROM    json_table
WHERE   j @> '{"key1": "10"}'::JSONB 
```



#### 6-3-2-5 执行结果

``` properties
 id |                                   j                                    
----+------------------------------------------------------------------------
 10 | {"key1": "10", "key2": "10", "key3": "10", "key4": "10", "key5": "10"}
(1 row)
```



#### 6-3-2-6 使用`explain`命令查看执行计划

``` properties
QUERY PLAN
Gather  (cost=0.00..39038928.99 rows=400000 width=88)
  ->  Exchange (Gather Exchange)  (cost=0.00..39038843.49 rows=400000 width=88)
        ->  Decode  (cost=0.00..39038843.37 rows=400000 width=88)
              ->  Bitmap Heap Scan on json_table  (cost=0.00..39038840.00 rows=400000 width=88)
"                    Recheck Cond: (j @> '{"key1": "10"}'::jsonb)"
                    ->  Bitmap Index Scan on index_json  (cost=0.00..0.00 rows=0 width=0)
"                          Index Cond: (j @> '{"key1": "10"}'::jsonb)"
Optimizer: HQO version 0.10.0
```

