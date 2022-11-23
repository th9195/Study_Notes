# 1- Explain查看执行计划

​		在 clickhouse <font color='red'>20.6 </font>版本之前要查看 SQL 语句的执行计划需要设置日志级别为 trace 才能

可以看到，并且只能真正执行 sql，在执行日志里面查看。在 20.6 版本引入了原生的执行计

划的语法。在 20.6.3 版本成为正式版本的功能。

<font color='red'>本文档基于目前较新稳定版21.7.3.14。</font>

## 1-1 基本语法

``` sql
EXPLAIN [AST | SYNTAX | PLAN | PIPELINE] [setting = value, ...] 
SELECT ... [FORMAT ...]
```

- **PLAN**：用于查看执行计划，<font color='red'>默认值</font>。

  - header 打印计划中各个步骤的 head 说明，默认关闭，默认值 0;
  - description 打印计划中各个步骤的描述，默认开启，默认值 1； 
  - actions 打印计划中各个步骤的详细信息，默认关闭，默认值 0;

- **AST** ：用于查看语法树;

- **SYNTAX**：用于优化语法; 

- **PIPELINE**：用于查看 PIPELINE 计划。 

  - header 打印计划中各个步骤的 head 说明，默认关闭; 
  - graph 用 DOT 图形语言描述管道图，默认关闭，需要查看相关的图形需要配合

  graphviz 查看；

  - actions 如果开启了 graph，紧凑打印打，默认开启

<font color='red'>注：PLAN  和  PIPELINE  还可以进行额外的显示设置，如上参数所示</font>





## 1-2 案例实操

### 1-2-1 新版本使用EXPLAIN

- 查看 PLAIN

  - 简单查询

  ``` sql
  explain plan select arrayJoin([1,2,3,null,null]);
  ```

  - 复杂 SQL 的执行计划

  ```sql
  explain select database,table,count(1) cnt from system.parts where 
  database in ('datasets','system') group by database,table order by 
  database,cnt desc limit 2 by database;
  ```

  - 打开全部的参数的执行计划

  ``` sql
  EXPLAIN header=1, actions=1,description=1 SELECT number from 
  system.numbers limit 10;
  ```

- AST 语法树

``` sql
EXPLAIN AST SELECT number from system.numbers limit 10;
```

- SYNTAX 语法优化

``` sql
# 先做一次查询
SELECT number = 1 ? 'hello' : (number = 2 ? 'world' : 'atguigu') FROM 
numbers(10);

# 查看语法优化
EXPLAIN SYNTAX SELECT number = 1 ? 'hello' : (number = 2 ? 'world' : 
'atguigu') FROM numbers(10);

# 开启三元运算符优化
SET optimize_if_chain_to_multiif = 1;

# 再次查看语法优化
EXPLAIN SYNTAX SELECT number = 1 ? 'hello' : (number = 2 ? 'world' : 
'atguigu') FROM numbers(10);

# 返回优化后的语句
SELECT multiIf(number = 1, \'hello\', number = 2, \'world\', \'xyz\')
FROM numbers(10)
```

- 查看 PIPELINE

``` sql
EXPLAIN PIPELINE SELECT sum(number) FROM numbers_mt(100000) GROUP BY 
number % 20; # 打开其他参数


EXPLAIN PIPELINE header=1,graph=1 SELECT sum(number) FROM 
numbers_mt(10000) GROUP BY number%20;
```



### 1-2-2 老版本查看执行计划

``` shell
clickhouse-client -h 主机名 --send_logs_level=trace <<< "sql" > /dev/null
```

​		其中，send_logs_level 参数指定日志等级为 trace，<<<将 SQL 语句重定向至 clickhouse-client 进行查询，> /dev/null 将查询结果重定向到空设备吞掉，以便观察日志。

<font color='red'>注意：</font>

- 通过将 ClickHouse 的服务日志，设置到 DEBUG 或者 TRACE 级别，才可以变相实现

  EXPLAIN 查询的作用。

- 需要真正的执行 SQL 查询，CH 才能打印计划日志，所以如果表的数据量很大，最好

  借助 LIMIT 子句，减小查询返回的数据量。







# 2- 建表优化

## 2-1 数据类型

### 2-1-1 时间字段的类型

### 2-1-2 空值存储类型

## 2-2 分区和索引

## 2-3 表参数

## 2-4 写入和删除优化

## 2-5 常见配置

### 2-5-1 CPU资源

### 2-5-2 内存资源

### 2-5-3 存储

# 3- Clickhouse 语法优化规则

# 4- 查询优化

# 5- 数据一致性（重点）

# 6- 物化视图

# 7- MaterializeMySQL引擎

# 8- 常见问题排查