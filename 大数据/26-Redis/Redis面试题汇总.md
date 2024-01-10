[TOC]

# 1- Redis 的功能？

- 提供高并发和搞性能数据存储，提供高速读写；



# 2- Redis的应用场景？

- 缓存：实现高并发的大数据量的请求缓存（临时存储）
- 数据库：实现高性能的数据读写（永久性存储）
- 消息队列：一般不用

# 3- Redis 的数据结构与数据类型？

- 数据结构：K-V结构
- 数据类型
  - Key:String;
  - Value:String , Hash , List , Set , Zset

# 4- 常用的命令有哪些？

- 基本命令：
  - keys , del , exists , type , expire(设置过期时间) , ttl（查看剩余时间） ,
  - select N（切换数据 db0-db15）, move key N (将某个Key移动到某个数据库中)
  - flushdb(清空当前数据库的所有Key)
- 类型命令
  - String：<font color='red'>set、get、mset、mget</font>
  - Hash：hset、hget、hgetall、hlen、hdel、hmset、hmget
  - List：<font color='red'>lpush、rpush、lrange、lpop、rpop</font>
  - Set：sadd、srem、scard（统计集合长度）
  - Zset：zadd、zrem、zrange、zrevrange、zcard

# 5- Redis如何实现数据持久化？

- **<font color='red'>RDB</font>** : 默认开启
  - **<font color='red'>思想</font>**：
    - **每次判断在一定时间内是否发生一定次数更新，如果满足条件，就构建一个全量内存数据快照存储在磁盘文件中**
  - 实现
    - 手动：save、bgsave、shutdown
    - 自动：save  时间  更新次数
  - 特点
    - 优点：**二进制文件，恢复比较快，基本与内存是一致的**
    - 缺点：<font color='red'>数据丢失的概率相对较高</font>
  - 应用：数据备份迁移，大数据量缓存
- <font color='red'>**AOF**</font>：默认不开启
  - **<font color='red'>思想</font>**：
    - **将内存数据的操作日志追加写入一个文件中**
    - 提供灵活的机制，可以自由选择<font color='red'>安全性</font>和<font color='red'>高性能</font>
  - 实现
    - always：内存写一条，磁盘同步一条
      - 安全，性能相对较差
    - everysec：每一秒同步一次到磁盘
      - 安全性和性能之间做了一个权衡
    - no：交给OS来做
      - 不安全
  - 特点
    - 优点：**追加方式去记录，自由选择方案**



# 6- Redis的两个问题，以及如何解决？

- **问题1：<font color='red'>单点故障问题</font>**，如果Redis服务故障，整个Redis服务将不可用；
- **问题2：<font color='red'>单台机器的内存比较小，单个服务能够接受的并发量比较固定</font>**，数据存储的容量不足，会导致redis无法满足需求

- **解决方案**：
  - <font color='red'>**主从复制集群**</font>  实现<font color='red'>读写分离的负载均衡</font>  <font color='red'>单点故障问题</font>；（但是存在Master单点故障问题）
  - **<font color='red'>哨兵模式 </font>**  解决  <font color='red'>Master单点故障</font>问题；
  - **<font color='red'>分片Cluster集群</font>**设计  解决 资源不足的问题；



# 7- Redis 的事务机制

- 一般不用事务： Redis本身是单线程的， 所以本身没有事务等概念；
- Redis支持事务 **<font color='red'>本质就是一组命令的集合</font>**  ,串行执行每个命令；
- 鸡肋： Redis事务没有回滚， 如果前面的命令执行失败，后面的命令也会执行；
- 过程：
  - 开启事务 : multi
  - 提交命令 : exec 
  - 执行事务 : 
  - 取消事务 : discard



# 8- Redis 的过期策略与内存淘汰机制

- **过期策略**：(<font color='red'>惰性过期 + 定期过期 配合使用</font>)
  - 设计思想：避免内存满，指定Key的存活时间，到达存活时间以后自动删除
    - expire / setex
  - **定时过期：**指定Key的存活时间，一直监听这个存活时间，一旦达到存活时间，自动删除
    - 需要CPU一直做监听，如果Key比较多，CPU的消耗比较严重
  - **<font color='red'>惰性过期</font>：** 指定Key的存活时间，当使用这个Key的时候，判断是否过期，如果过期就删除
    - 如果某个Key设置了过期时间，但是一直没有使用，不会被发现过期了，就会导致资源浪费
  - **<font color='red'>定期过期:</font>** 每隔一段时间就检查数据是否过期，如果过期就进行删除
    - 中和的策略机制

- **淘汰机制** : (**<font color='red'>lru : 最近最少使用的key</font>**)
  - 实际项目中设置内存淘汰策略：maxmemory-policy allkeys-lru，移除最近最少使用的key



# 9- Redis 的多数据机制，了解多少？ 

- Redis 支持多数据库，并且每个数据库中的数据是隔离的不能共享，单机下的Redis可以支持16个数据库（db0--db15）

- 在Redis Cluster 集群架构下只有一个数据库空间 db0 。 因此，我们没有使用Redis的多数据库功能；



# 10- 懂Redis的批量操作么？

- 懂一点。 比如mset 、mget 、hmset 、hmget ;
- 如果是Cluster集群架构，不同key会划分到不同的slot中，因此直接使用mset  或者 mget 是行不通的；
- 如果是Cluster集群架构， 就必须使用Hashtag保证这些Key映射到同一台redis节点；
- 如： key 为 {foo}.student1 ,  {foo}.student2 , {foo}.student3,  这类key一定会在同一个redis节点。因为key中{} 之间的字符串就是当前的Hash tags， 只有{}中的部分才被用来做hash，因此计算出来的redis节点一定是同一个；

# 11- Redis集群架构 有什么不足？

- 批量操作比较麻烦；

# 12- 什么是缓存穿透（key没有）？怎么解决？

- 理解：
  - 客户端高并发不断向Redis请求一个**<font color='red'>不存在的key</font>** , 而**Mysql中也没有**；
  - 由于Redis没有，导致并发全部落在Mysql上，加大了mysql的压力；

- 解决：
  - 对于高频次的IP 进行限制；
  - 如果Redis 和 Mysql都没有，就在redis中设置一个临时默认值；
  - 利用BitMap类型构建**布隆过滤器**；

# 13- 什么是缓存击穿（key过期）？ 怎么解决？ 

- 理解：
  - 有一个key需要高并发的访问，但这个key 有过期时间， 一旦到期，这个key被删除，所有的高并发就落在Mysql上；
- 解决：
  - 资源充足情况下，**设置永不过期**；
  - **闭环设计**： <font color='red'>当redis 没有这个key，就去Mysql里面读取，读到后立即写入redis;</font>

# 14- 什么是缓存雪崩（同时大量Key过期）？ 怎么解决？

- 理解：
  - <font color='red'>大量的Key在同一个时间段过期，大量的Key在Redis中没有，都去请求Mysql.导致Mysql崩溃；</font>
- 解决：
  - 资源充足情况下，**设置大部分的Key永久不过期**；
  - 给所有的Key 设置过期时间上加 个 **<font color='red'>随机值</font>**，让Key不再同一时间过期；



# 15- Redis中Key怎么设计？ 

- 使用统一的命名规范：
  - 业务名:表名:id  
  - 如果： shop:usr:msg_code
- 控制key名称的长度，能缩写就缩写；
- 名称不要包含特殊字符、空格、单双引号、转义字符；



# 16- 为什么Redis是单线程的？

- 纯内存操作，CPU不是Redis的瓶颈；
- 使用I/O复用模型，非阻塞IO；
- 数据结构简单，对数据的操作也简单；
- 单线程避免了上下文的切换和竞争条件；



# 17- Redis6.0为什么要引入多线程？

- Redis 将所有数据都放在内存，内存的响应时长大约为100ns;
- 对于小数据包，Redis服务器的极限可以处理8万到10万 QPS;
- 但是有些复杂业务场景，需要更大的QPS；
- 解决方案： 
  - 方案一：分布式集群： 但是维护成本高，命令受限，容易产生数据热点倾斜；
  - 方案二：Redis优化网络模型以及CPU多线程模型；
- Redis6.0默认不开启多线程；























