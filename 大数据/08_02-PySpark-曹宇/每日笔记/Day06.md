# Spark DataFrame 操作API

## DSL  和 SQL

DSL: 领域特定语言

SQL: 结构化查询语言



DSL就是通过API来查询数据,  也就是算子,  df.where   df.select

SQL就是通过写SQL语句查询, spark.sql("SELECT xxx FROM xxx WHERE xxx")



DSL和SQL 都是完全可以胜任工作的, 具体用哪一个, 个人选择, (建议用DSL)







##  DataFrame算子

### show

功能: 将DataFrame的内容, 打印到屏幕上

默认打印20条,   可以传参 告知打印多少条. `show(100)`



默认对于超长的列 是只显示20个字符, 如果要突破限制,可以: `show(truncate = False)`





### printSchema

功能: 输出DataFrame的Schema信息



```shell
>>> df.printSchema()
root
 |-- name: string (nullable = true)
```



### select

功能: 选择DF中的列



```shell
# select算子 接受  字符串`列名`  或者Column对象的传入, 用来确定所要的列

# df[列名字] 可以返回这个列的Column对象
# SELECT算子
df.select('name', 'age').show()
df.select(df['name'], df['age']).show()
```



### where 和 filter

功能: 过滤行数据



```shell
# WHERE Filter算子
# 两个算子功能一样, 传入的参数同样是  类型1: 字符串形式 如 'age > 10'   类型2: column形式  df['age'] > 10
df.filter('age > 96').show()
df.filter(df['age'] > 96).show()
df.where('age > 96').show()
df.where(df['age'] > 96).show()
```





### groupBy

功能: 按照指定的列, 数据进行分组



```shell
# groupBy 算子
df.groupBy('name').count().show()
```

> groupBy返回值不是DataFrame, 而是: <class 'pyspark.sql.group.GroupedData'>
>
> 目的就是让你对这个对象继续做操作, 因为分组一般用来做聚合
>
> 可以后接:
>
> - count
> - min
> - max
> - avg(string类型的列名)
> - sum
>
> 聚合函数





### orderBy

功能: 根据指定的列 进行 结果集的排序



语法:

```shell
# 参数1 是排序的依据列(可以传多个), 可以穿字符串, 也可以传递 Column对象
# 参数2: 升序或者降序  ascending=False 表示降序操作 True表示升序
.orderBy('count', ascending=False)\
```



### DataFrame的count算子

对DataFrame的数据执行count计算



返回值: 是一个int对象





### withColumnRenamed

功能: 将老列名 改为新列名



```shell
# 注意, 参数1 老列名, 参数2 新列名
# 注意, 不接受Column对象, 只接受字符串
df.withColumnRenamed('count', 'cnt')
```









### spark.read.format("text") text数据源

功能: 从文本文件中读取数据

特点: 

1. 读取后, 不管数据是啥样, 只有一个列, 一行数据都在列中 列名叫做`value`





### selectExpr

功能: 可以在select中使用表达式(函数计算)

```shell
df.selectExpr("explode(split(value, ' '))").show()
```





### pyspark.sql.functions 包

这个包里面 包含了 所有SparkSQL所提供的 内置函数

使用方式:

```python
from pyspark.sql import functions as F

f.函数使用
```

![image-20210828105535404](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828105535.png)

如图, 内置函数不少



### split函数和explode函数

函数内置在pyspark.sql.functions 包内

split等同于SQL中的Split函数

explode等同于SQL中的explode函数



语法:

```shell
from pyspark.sql import functions as F
F.split('被切分的列名', 切分依据)	返回值是Column对象
F.explode('需要被爆炸的列名') 返回值是Column对象

# 示例
df.select(F.explode(F.split('value', ' '))).show()
# 解释: 由于select接受column对象, 这两个方法返回也是column 所以可以在select中调用
```



### alias

功能: 对Column对象进行改名



注意: withColumnRenamed是针对DF对象进行改名, 改哪个列都行

alias是针对单个Column对象使用



```shell
df.groupBy("userid").\
    agg(
        F.round(F.avg(df['rank']), 2).alias("avg_rank"),
        F.min(df['rank']).alias('min_rank'),
        F.max(df['rank']).alias('max_rank'),
        F.sum(df['rank']).alias('sum_rank')
    ).show()

# 如上代码, 聚合函数返回的值是Column对象, 所以可以直接调用alias改名
```





### dropDuplicates

功能: 对数据进行去重, 删除重复的多余数据

语法:

```shell
# 无参数使用, 表示对数据整体进行去重判断
df.dropDuplicates()

#  在这个方法里面可以传入一个list, list里面是字符串 用来标记列名
# 意思是 指定某个列进行去重
# 如果在去重的时候, 这个字段重复的数据有许多条, 那么保留第一条
df.dropDuplicates(['age']).show()
```



### dropna

功能: 删除异常值数据

语法:

```shell
# how 可选, 默认是any 表示有null就删除,  也可以填 all, 表示所有列为null才删除行
# thresh 可选, 表示必须达到规定的有效字段数量 这行数据才被保留. 一旦使用这个参数 how参数失效
# subset字段 可选, 表示指定列进行判断 传入的是list, list内是列名的字符串
df.dropna(thresh=2, subset=['name', 'age']).show()
```



### fillna

功能: 填充异常值, 填上所需的内容

```shell
# 可传入参数有两种方式:
# 方式1: 传入一个单值, 填充符合此类型的列的异常值, 比如传入50, 针对int列的null都补充为50
df.fillna(50)

# 方式2: 传入一个字典, 针对每个列 都可以给出填充null的内容, 如下:
df.fillna({
    "age": 0,
    "name": "Unknow",
    "job":"码农"
}).show()
```





## GroupedData中的算子

GroupedData对象是: `<class 'pyspark.sql.group.GroupedData'>`

此对象是, 调用`df.groupBy`后得到的返回值.

表示是一个分好组的数据结构.

这个对象有其特有的方法

### count 单次聚合

功能: 对`<class 'pyspark.sql.group.GroupedData'>`类型的数据, 执行计数操作



注意: count后, 列名默认叫做count

返回值: DataFrame



同类型还有

- avg
- min
- max
- sum



### agg 聚合

特点: 可以在agg内写多个聚合方法

功能: 对GroupedData对象进行聚合计算



```shell
df.groupBy("userid").\
    agg(
        F.round(F.avg(df['rank']), 2).alias("avg_rank"),
        F.min(df['rank']).alias('min_rank'),
        F.max(df['rank']).alias('max_rank'),
        F.sum(df['rank']).alias('sum_rank')
    ).show()

# 如上 可以看到, agg内可以写多个聚合方法, 以逗号分开即可
# 每个聚合方法 要求返回值是Column对象
```





## SparkSQL将数据写出

通过统一API的形式写出:

```shell
df.write.\
	mode(savemode).\
	option(k, v).\
	format('数据源').\
	save('路径')
mode 传入字符串. 可选:
- overwrite 覆盖
- append 追加
- error 遇到文件已存在 直接报错
- ignore 遇到文件已存在 不干活忽略

option设置属性, 可以写好多个
format是数据源格式, 支持写出:
- text
- csv
- json
- paruqet
- jdbc
```



```python
# coding:utf8
# 演示将DataFrame通过统一API写出到外部去
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, IntegerType, StringType

if __name__ == '__main__':
    spark = SparkSession.builder\
        .config("spark.sql.shuffle.paratitions", "4")\
        .appName("test")\
        .master("local[*]")\
        .getOrCreate()
    sc = spark.sparkContext

    schema = StructType().\
        add("name", StringType(), True).\
        add("age", IntegerType(), True).\
        add("job", StringType(), True)
    df = spark.read.format("csv").\
        option("sep", ";").\
        option("header", True).\
        schema(schema).\
        load("../data/sql/people.csv")

    # Spark写外部数据源支持: Text, csv, json, parquet, jdbc

    # 1. 将数据以text格式写出, text写出数据 是写出单列, 要么df是1个列, 要么你转换成1个列
    df.select(F.concat_ws(",", "name", "age", "job")).\
        write.\
        mode("overwrite").\
        format("text").\
        save("../data/sql/output/text")

    # 2. 将数据写出为json格式
    df.write.\
        mode("overwrite").\
        format("json").\
        save("../data/sql/output/json")

    # 3. 将数据写出为csv格式
    df.write.\
        mode("overwrite").\
        option("sep", ",").\
        option("header", True).\
        format("csv").\
        save("../data/sql/output/csv")

    # 4. 将数据写出为parquet格式
    df.write.\
        mode("overwrite").\
        format("parquet").\
        save("../data/sql/output/parqeut")
```



## SparkSQL 读写JDBC数据源

```python
# coding:utf8
# 演示Spark读取JDBC数据和写出JDBC数据
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, IntegerType, StringType

if __name__ == '__main__':
    spark = SparkSession.builder\
        .config("spark.sql.shuffle.paratitions", "4")\
        .appName("test")\
        .master("local[*]")\
        .getOrCreate()
    sc = spark.sparkContext

    # 数据库地址
    # 端口
    # 账号密码
    # 数据库
    # 表
    df = spark.read.\
        option("url", "jdbc:mysql://node1:3306/test?useSSL=false").\
        option("dbtable", "people").\
        option("user", "root").\
        option("password", "123456").\
        format("jdbc").\
        load()

# 读取数据的时候, 由于数据库表是带有Schema的, 所以我们无需设置DF的Schema相关内容
# 直接可以读出来.
        
    # 将数据写出到数据库中
    df.write.\
        mode("append").\
        option("url", "jdbc:mysql://node1:3306/test?useSSL=false"). \
        option("dbtable", "people2"). \
        option("user", "root"). \
        option("password", "123456"). \
        format("jdbc").\
        save()
# 写出的时候, 如果表不存在 会自动创建
# 创建表的时候 因为DataFrame是自带Schema的 所以Spark会基于DF的Schema来创建MySQL数据库的表
```



## SparkSQL 自定义UDF函数

### 注册方法

```shell
# 先定义一个方法
# TODO: 1 定义一个返回Int值的UDF函数
def add_one(data):
    return data + 1

# 方式1: 参数1 udf函数本体, 参数2: 返回值类型
from pyspark.sql import functions as F
udf_add_one = F.udf(add_one, IntegerType())

# 方式2: 参数1: udf的名字, 参数2 udf函数本体, 参数3: 返回值类型
udf_add_one_reg2 = spark.udf.register("udf_add_one_reg1", add_one, IntegerType())
```



方式1 注册只能用于DSL风格



方式2 的注册 可以用于DSL和SQL风格

- register方法中参数1给出的名字字符串,  可以作为udf用于SQL风格中
- register方法的返回值对象, 可以用于DSL风格中



> 方式2 最通用 2种风格都可以用.



### 注意

注册UDF的时候 声明的返回值 是啥类型, 就要返回啥类型, 不然会报错



### 演示代码 声明Int类型的UDF

```python
# coding:utf8
# 演示Spark定义UDF函数
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, IntegerType, StringType

if __name__ == '__main__':
    spark = SparkSession.builder\
        .config("spark.sql.shuffle.paratitions", "4")\
        .appName("test")\
        .master("local[*]")\
        .getOrCreate()
    sc = spark.sparkContext

    schema = StructType().add("num", IntegerType(), False)
    df = sc.parallelize([1,2,3,4,5]).map(lambda x: [x]).toDF(schema)

    # TODO: 1 定义一个返回Int值的UDF函数
    def add_one(data):
        return data + 1

    # 方式1: 参数1 udf函数本体, 参数2: 返回值类型
    udf_add_one = F.udf(add_one, IntegerType())
    # 方式2: 参数1: udf的名字, 参数2 udf函数本体, 参数3: 返回值类型
    udf_add_one_reg2 = spark.udf.register("udf_add_one_reg1", add_one, IntegerType())

    df.select(udf_add_one('num')).show()
    # 方式1 无法使用SQL风格 但是可以使用DSL风格
    # df.selectExpr('udf_add_one(num)').show()

    df.select(udf_add_one_reg2('num')).show()
    df.selectExpr("udf_add_one_reg1(num)").show()
```



### 演示代码 声明Float类型的UDF

```python
# coding:utf8
# 演示Spark定义UDF函数
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, IntegerType, StringType, FloatType

if __name__ == '__main__':
    spark = SparkSession.builder\
        .config("spark.sql.shuffle.paratitions", "4")\
        .appName("test")\
        .master("local[*]")\
        .getOrCreate()
    sc = spark.sparkContext

    schema = StructType().add("num", FloatType(), False)
    df = sc.parallelize([1.1,2.2,3.3,4.4,5.5]).map(lambda x: [x]).toDF(schema)

    # TODO: 1 定义一个返回Int值的UDF函数
    def add_one(data):
        return data + 1.0

    # 方式1: 参数1 udf函数本体, 参数2: 返回值类型
    udf_add_one = F.udf(add_one, FloatType())
    # 方式2: 参数1: udf的名字, 参数2 udf函数本体, 参数3: 返回值类型
    udf_add_one_reg2 = spark.udf.register("udf_add_one_reg1", add_one, FloatType())

    df.select(udf_add_one('num')).show()
    # 方式1 无法使用SQL风格 但是可以使用DSL风格
    # df.selectExpr('udf_add_one(num)').show()

    df.select(udf_add_one_reg2('num')).show()
    df.selectExpr("udf_add_one_reg1(num)").show()
```





### 演示代码 声明ArrayType类型的UDF函数

注意: 声明ArrayType需要:

```shell
# 需要声明其内部数据的类型
ArrayType(IntegerType())
```



```python
# coding:utf8
# 演示Spark定义UDF函数
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, IntegerType, ArrayType

if __name__ == '__main__':
    spark = SparkSession.builder\
        .config("spark.sql.shuffle.paratitions", "4")\
        .appName("test")\
        .master("local[*]")\
        .getOrCreate()
    sc = spark.sparkContext

    schema = StructType().add("num", IntegerType(), False)
    df = sc.parallelize([1,2,3,4,5]).map(lambda x: [x]).toDF(schema)

    # TODO: 1 定义一个返回ArrayType值的UDF函数
    def add_one(data):
        return [data, data * 10]

    # 方式1: 参数1 udf函数本体, 参数2: 返回值类型
    udf_add_one = F.udf(add_one, ArrayType(IntegerType()))
    # 方式2: 参数1: udf的名字, 参数2 udf函数本体, 参数3: 返回值类型
    udf_add_one_reg2 = spark.udf.register("udf_add_one_reg1", add_one, ArrayType(IntegerType()))

    df.select(udf_add_one('num')).show()
    # 方式1 无法使用SQL风格 但是可以使用DSL风格
    # df.selectExpr('udf_add_one(num)').show()

    df.select(udf_add_one_reg2('num')).show()
    df.selectExpr("udf_add_one_reg1(num)").show()
```



### 演示代码 声明一个StructType类型返回值的UDF函数



可以将udf注册的时候的返回值声明为:StructType

这个StructType在DF中, 当做字典使用

那么, 就可以在里面混合各种类型 比如在内部可以混合 数字 字符串 日期 等各种类型

```python
# coding:utf8
# 演示Spark定义UDF函数
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, IntegerType, ArrayType, StringType

if __name__ == '__main__':
    spark = SparkSession.builder\
        .config("spark.sql.shuffle.paratitions", "4")\
        .appName("test")\
        .master("local[*]")\
        .getOrCreate()
    sc = spark.sparkContext

    schema = StructType().add("num", IntegerType(), False)
    df = sc.parallelize([1,2,3,4,5]).map(lambda x: [x]).toDF(schema)

    # TODO: 1 定义一个返回StructType值的UDF函数
    def add_one(data):
        return [data, str(data * 10) + "_嘿嘿嘿"]


    udf_return_schema = StructType().add("num", IntegerType(), False).add("str", StringType(), True)
    # 方式1: 参数1 udf函数本体, 参数2: 返回值类型
    udf_add_one = F.udf(add_one, udf_return_schema)
    # 方式2: 参数1: udf的名字, 参数2 udf函数本体, 参数3: 返回值类型
    udf_add_one_reg2 = spark.udf.register("udf_add_one_reg1", add_one, udf_return_schema)

    df.select(udf_add_one('num')).show()
    # 方式1 无法使用SQL风格 但是可以使用DSL风格
    # df.selectExpr('udf_add_one(num)').show()

    df.select(udf_add_one_reg2('num')).show()
    df.selectExpr("udf_add_one_reg1(num)").show()
```





## SparkSQL 窗口(开窗)函数

SparkSQL 支持SQL中常见的开窗函数:

- 聚合窗口函数: COUNT() OVER()\    SUM() OVER()
- 排序窗口函数: RANK() OVER()\   DENSE_RANK() OVER()\ ROW_NUMBER() OVER()
- 等分排序创空间函数: NTILE() OVER()

如下是代码演示:

```python
# coding:utf8
# 演示Spark的窗口(开窗)函数
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, IntegerType, ArrayType, StringType

if __name__ == '__main__':
    spark = SparkSession.builder\
        .config("spark.sql.shuffle.paratitions", "4")\
        .appName("test")\
        .master("local[*]")\
        .getOrCreate()
    sc = spark.sparkContext

    rdd = sc.parallelize([
        ('张三', 'class_1', 99),
        ('王五', 'class_2', 35),
        ('王三', 'class_3', 57),
        ('王久', 'class_4', 12),
        ('王丽', 'class_5', 99),
        ('王娟', 'class_1', 90),
        ('王军', 'class_2', 91),
        ('王俊', 'class_3', 33),
        ('王君', 'class_4', 55),
        ('王珺', 'class_5', 66),
        ('郑颖', 'class_1', 11),
        ('郑辉', 'class_2', 33),
        ('张丽', 'class_3', 36),
        ('张张', 'class_4', 79),
        ('黄凯', 'class_5', 90),
        ('黄开', 'class_1', 90),
        ('黄恺', 'class_2', 90),
        ('王凯', 'class_3', 11),
        ('王凯杰', 'class_1', 11),
        ('王开杰', 'class_2', 3),
        ('王景亮', 'class_3', 99)
    ])
    schema = StructType().\
        add("name", StringType(), False).\
        add('class', StringType(), False).\
        add('score', IntegerType(), False)
    df = rdd.toDF(schema)
    df.createTempView("score")

    # TODO: 1. 聚合开窗函数
    # spark.sql("""
    #     SELECT name, class, score, COUNT(*) OVER() FROM score
    # """).show()

    # spark.sql("""
    #         SELECT name, class, score, COUNT(*) OVER(PARTITION BY class) FROM score
    #     """).show()

    # TODO: 2. 排序开窗函数, 注意必须带上order by 子句
    # spark.sql("""
    #     SELECT name, class, score,
    #     ROW_NUMBER() OVER(ORDER BY score) AS row_number,
    #     RANK() OVER(PARTITION BY class ORDER BY score DESC) AS rank,
    #     DENSE_RANK() OVER(PARTITION BY class ORDER BY score) AS dense_rank
    #     FROM score
    # """).show()

    # TODO: 3. 等分排序开窗函数 ntile
    spark.sql("""
        SELECT name, class, score,
        NTILE(3) OVER(PARTITION BY class ORDER BY score DESC) AS ntile
        FROM score
    """).show()
```









## SQL风格入门演示

写SQL语句查询, 第一要素要有: `表`

写SQL风格 第一件事, 将DF注册成一张表格



### 临时表和全局表

临时表; 只能在当前SparkSession中使用

全局表;可以在所有的SparkSession中使用

> 注意: 全局表注册的表, 在调用的时候 要加上: `global_temp.` 使用
>
> 比如 注册全局表叫做`stu`
>
> 在调用的时候, 表名叫做: `global_temp.stu`





### DF注册成表

```shell
df.createTempView("stu")			# 注册临时表
df.createOrReplaceTempView("stu")	# 注册 或 替换 临时表
df.createGlobalTempView("stu")		# 注册全局表
```



### 执行SQL查询

```shell
# 通过SparkSession对象的sql方法, 写入SQL查询语句集合执行计算
# 返回值是一个DataFrame对象
spark.sql("SELECT * FROM stu").show()
spark.sql("SELECT name, COUNT(*) AS cnt, SUM(age) AS age_sum FROM stu GROUP BY name").show()
```





## SparkSQL WordCount 案例

```python
# coding:utf8

from pyspark.sql import SparkSession
from pyspark.sql import functions as F

if __name__ == '__main__':
    spark = SparkSession.builder\
        .config("spark.sql.shuffle.paratitions", "4")\
        .appName("test")\
        .master("local[*]")\
        .getOrCreate()
    sc = spark.sparkContext

    rdd = sc.textFile("hdfs://node1:8020/input/words.txt").\
        flatMap(lambda x: x.split(' ')).\
        filter(lambda x: x.strip()).\
        map(lambda x: [x])
    df = rdd.toDF(['word'])

    # DSL 风格
    df.groupBy('word').count()\
        .withColumnRenamed('count', 'cnt')\
        .orderBy('cnt', ascending=False)\
        .show()

    # 纯SparkSQL风格数据读取
    df = spark.read.format("text").load("hdfs://node1:8020/input/words.txt")

    df2 = df.selectExpr("explode(split(value, ' '))")
    df3 = df2.withColumnRenamed('col', 'word')
    df3.groupBy('word').count().orderBy('count', ascending=False).show()


    # 使用Spark的内置函数来计算
    df2 = df.select(F.explode(F.split('value', ' ')))
    df3 = df2.withColumnRenamed('col', 'word')
    df3.groupBy('word').count().orderBy('count', ascending=False).show()
```





## 电影评分数据分析案例

### 需求和数据

数据:

![image-20210828115550599](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828115550.png)

数据4个列:

- 列1: 用户id
- 列2: 电影id
- 列3: 评分
- 列4: 时间戳

分隔符是`\t`



数据下载地址:

```shell
http://files.grouplens.org/datasets/movielens/ml-100k/u.data
```



需求:

```shell
1.查询用户平均分
2.查询电影平均分
3.查询大于平均分的电影的数量
4.查询高分电影中(>3)打分次数最多的用户, 并求出此人打的平均分
5.查询每个用户的平均打分, 最低打分, 最高打分
6.查询被评分超过100次的电影, 的平均分 排名 TOP10
```



### 代码

```python
# coding:utf8

from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, IntegerType, StringType

if __name__ == '__main__':
    spark = SparkSession.builder\
        .config("spark.sql.shuffle.paratitions", "4")\
        .appName("test")\
        .master("local[*]")\
        .getOrCreate()
    sc = spark.sparkContext

    # 定义一个StructType来构建df的schema
    schema = StructType().\
        add("userid", StringType(), False).\
        add("movie_id", StringType(), False).\
        add("rank", IntegerType(), False).\
        add("ts", StringType(), False)
    df = spark.read.\
        option("sep", '\t').\
        option("header", False).\
        schema(schema).\
        format("csv").\
        load("../data/sql/u.data")
    df.createTempView("movies")

    # 查询用户平均分
    # 按用户分组 求rank平均值
    df.groupBy('userid').avg('rank').\
        withColumnRenamed("avg(rank)", "avg_rank").\
        selectExpr("userid", "round(avg_rank, 2) as avg_rank").show()

    # 查询电影平均分
    spark.sql("""
        SELECT movie_id, round(avg(rank), 2) AS rank_avg FROM movies GROUP BY movie_id
    """).show()

    # 查询大于平均分的电影的数量
    # df.select(F.avg(df['rank'])).show()
    cnt = df.where(df['rank'] > df.select(F.avg(df['rank'])).first()['avg(rank)']).count()
    print("大于平均分的电影数量:", cnt)

    # 查询高分电影中(>3)打分次数最多的用户, 并求出此人打的平均分
    # 思路: 先过滤数据得到高分电影, 然后按照用户分组求打分次数, 倒叙排序打分次数, limit 1
    df2 = df.filter(df['rank'] > 3).\
        groupBy('userid').\
        count().\
        orderBy('count', ascending=False).\
        limit(1)
    # 得到用户后, 通过filter过滤数据 只保留此用户打分数据, 对此用户进行groupby分组 求avg评分
    df.filter(df['userid'] == df2.first()['userid']).\
        groupBy("userid")\
        .avg("rank").show()

    # 查询每个用户的平均打分, 最低打分, 最高打分
    df.groupBy("userid").\
        agg(
            F.round(F.avg(df['rank']), 2).alias("avg_rank"),
            F.min(df['rank']).alias('min_rank'),
            F.max(df['rank']).alias('max_rank'),
            F.sum(df['rank']).alias('sum_rank')
        ).show()

    # 查询被评分超过100次的电影, 的平均分 排名 TOP10
    df.groupBy('movie_id').\
        agg(
            F.count('rank').alias("cnt"),
            F.avg('rank').alias("avg_rank")
        ).\
        where('cnt > 100').\
        orderBy('avg_rank', ascending=False).\
        limit(10).\
        show()
```





# SparkSQL shuflle阶段的分区数量

SparkSQL 在进行Shuffle阶段的时候, 分区(并行)的数量, 不受到spark默认并行度的约束.

它有自己独立的默认值: 200

正常情况下, sparksql 的shuffle阶段 都会产生200个分区(并行)来进行计算.



如果要修改, 可以设置参数:

可以修改: spark-defaults.conf

```shell
spark.sql.shuffle.paratitions 4
```





在代码中:

```python
spark = SparkSession.builder \
    .config("spark.sql.shuffle.paratitions", "4") \
    .appName("test")\
    .master("local[*]")\
    .getOrCreate()
    # 如上 通过config api来设置此属性
```





## 注意

这个参数 不重要, 重要的是, 它是独立在默认全局并行度之外的.

需要单独设置, 这个要注意到.



因为, 如果你不注意有这个问题,可能:

1. 设置的全局并行度1000, 但是sql的shuffle按照200跑, 略低 拖慢性能
2. 如果集群资源不足, 跑的数据又很大. 你设置的全局并行度是20, 但是sql的shuffle按照200跑, 可能会把内存跑炸掉.



> 在提交大任务计算的时候, 要想到对这个参数也进行单独设置.





# 结构化-半结构化-非结构化数据

概念:

## 结构化

可以被`固定Schema`所描述的数据 称之为结构化数据.



大白话: 可以形成一张二维表格的数据 就是结构化数据



举例:

- csv
- 数据库中的表
- SparkSQL中的DataFrame



## 半结构数据

概念: 可以用Schema描述的数据, 但是Schema不是固定的 是动态的



- json
- xml
- yaml
- peoperties
- ini



### 非结构化数据

概念: 无法用schema描述的数据



举例:

- avi
- mp4
- mp3
- jpg
- gif

> Spark是有能力处理非结构化数据的
>
> SparkSQL 完全无法处理非结构化数据





# SparkSQL的 执行流程

RDD:

![image-20210828171932889](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828171932.png)
RDD代码 -> DAGScheduler去规划Task -> TaskScheduler拿到Task后 去将Task分配到Executor干活 -> Executor干活





SparkSQL:

![image-20210828172012574](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828172012.png)

代码 -> Catalyst 生成执行计划 -> 经过各种优化 -> 转成RDD -> DAGScheduler去规划Task -> TaskScheduler拿到Task后 去将Task分配到Executor干活 -> Executor干活



> 结论: SparkSQL的代码, 最终都会被优化后 转换成RDD代码去执行







## 为什么SparkSQL代码可以优化 RDD不行

- RDD内存放的数据 是不确定的, 没有固定Schema
- DataFrame内存放的数据是有Schema的



也就是 DataFrame 永远是二维表结构 可以被针对

RDD不行.



RDD的优化, 需要编程人员自己通过代码去努力了.







## Catalyst优化器

![image-20210828172553190](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828172553.png)

如图, 粗略的SparkSQL执行流程:

- SparkSQL代码
- 经过优化器Catalyst优化
- 优化后形成RDD代码
- RDD去运行





![image-20210828173714163](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828173714.png)

如图, 如果正常执行SQL ,是应先执行JOIN 形成两张表的笛卡尔积, 然后再执行WHERE中的过滤



这个SQL在优化上, 其实应该,先将person.age > 10 先执行了  再执行JOIN

这样可以减少JOIN的数据量

这是写的SQL的一个失误/



SPARK的Catalyst 可以对SQL执行优化.



### Step1

![image-20210828173851543](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828173851.png)

解析SQL, 形成右侧的一个 AST抽象语法数, 简单认为 就是从下到上的顺序执行.



### Step2

![image-20210828173929944](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828173930.png)

在语法树中加入标记的元数据, 方便后续多语法数的节点进行操作



### Step3 重要

![image-20210828173955576](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828173955.png)

如图, 语法树 会经过优化, 首先进行:

- 断言下推 Predicate Pushdown, 将产生决断(判断)的语法节点(图中的Filter) 将其向下推送, 推送到关联节点之前执行预决断

  通俗理解: 先执行行过滤

- 列值裁剪: Column Pruning, 将进行关联之前, 对无关的列进行必要的裁剪, 减少在Shuffle阶段洗牌的数据量

  通俗理解: 再执行列过滤(减少行的宽度)



#### Step4

最后一步, 在Catalyst中 参数具体的逻辑执行计划和物理执行计划



通俗理解, 有了计划书 可以按照计划书 去设计RDD代码.



> 因为SparkSQL最后还是以RDD执行







## SparkSQL 执行流程的结论

DataFrame -> 逻辑计划 -> 优化 -> 物理计划 -> RDD代码 -> Driver -> DAG Scheduler -> Task Scheduler -> Executor Running.



大方向:

DF -> RDD -> Executor





# SparkSQL 和 Hive整合

性能: Saprk是绝对快于Hive的





## 回顾Hive

Hive有2个最重要的功能:

1. SQL翻译优化器 :  SQL -> MapReduce 代码 -> 提交到YARN运行
2. 元数据管理: Metastore服务, 通过将元数据存放在MySQL来管理整个数据库的元数据.



元数据管理:

记录你创建的表, 创建的库 存在HDFS什么地方

以及你建的表存放的数据的内容结构是什么, 分隔符是啥. 等一系列元数据



比如:

在hive中有表叫做 test, 存放在defualt数据库中, test表有2个列  id int  name string



元数据所记录的就是:

1. test表和数据库的关系(数据default库)
2. test表的数据存储位置: 比如: hdfs://node1:8020/user/hive/warehouse/default.db/test
3. test表的列机构, 2个列 类型是什么,  数据存放的分隔符是什么.



这些东西就是hive所管理的元数据, 统统存储在外部数据库中, 比如mysql





## Spark On Hive

如果能够完成:

1. SQL翻译优化器 :  SQL -> `SparkRDD代码` -> 提交到YARN运行
2. 元数据管理: Metastore服务, 通过将元数据存放在MySQL来管理整个数据库的元数据.









上述功能就是Spark On Hive

本质上来说就是: 一切都是Spark来做, 维度元数据管理使用hive的metastore服务

![image-20210828175944330](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828175944.png)



所以, Spark On Hive就是:

1. Hive的Metastore提供元数据管理

2. Spark提供 SQL语句转RDD并提交到集群的功能

   > SQL转RDD , Spark SQL 本来就可以 通过Catalyst





## Spark On Hive的配置

步骤1:

在Spark的conf文件夹中, 创建hive-site.xml, 内容如下

```shell
<configuration>
    <property>
      <name>hive.metastore.warehouse.dir</name>
      <value>/user/hive/warehouse</value>
    </property>
    <property>
      <name>hive.metastore.local</name>
      <value>false</value>
    </property>
    <property>
      <name>hive.metastore.uris</name>
      <value>thrift://node1:9083</value>
    </property>
 </configuration>
 # hive.metastore.warehouse.dir告知Spark hive默认的仓库地址
 # hive.metastore.uris 告知Spark , Hive的元数据服务(metastore)的地址
```



步骤2:

将MySQL的驱动jar包 放入Spark的jars文件夹中

jar在课程资料有提供

![image-20210828180429460](https://image-set.oss-cn-zhangjiakou.aliyuncs.com/img-out/2021/08/28/20210828180429.png)

MySQL 5.X 用 5.1.41.jar

MySQL 8.X 用8.0.13.jar



步骤3:

确保你的Hive 配置的metastore服务

确保hive的配置有如下:

```xml
<configuration>
    <property>
        <name>hive.metastore.uris</name>
        <value>thrift://node1:9083</value>
    </property>
</configuration>
```





步骤4:

启动Hive的Metastore服务

```shell
# 前台启动
/export/server/hive/bin/hive --service metastore
# 后台启动
nohup /export/server/hive/bin/hive --service metastore 2>&1 >> /var/log.log &
```





可以启动:

`$SPARK_HOME/bin/pyspark`

`$SPARK_HOME/bin/spark-sql`



这两个服务  来在里面直接写代码查询







PyCharm中代码连接Hive

主需要在构建SparkSession的时候:

```shell
.config("spark.sql.warehouse.dir", "hdfs://node1:8020/user/hive/warehouse")\
        .config("hive.metastore.uris", "thrift://node1:9083")\
        .enableHiveSupport()\
```



```python
# coding:utf8
# 演示Spark的窗口(开窗)函数
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, IntegerType, ArrayType, StringType

if __name__ == '__main__':
    spark = SparkSession.builder\
        .config("spark.sql.shuffle.paratitions", "4")\
        .appName("test")\
        .master("local[*]")\
        .config("spark.sql.warehouse.dir", "hdfs://node1:8020/user/hive/warehouse")\
        .config("hive.metastore.uris", "thrift://node1:9083")\
        .enableHiveSupport()\
        .getOrCreate()

    spark.sql("SELECT * FROM test.student").show()
```











