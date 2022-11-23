
## 事务的四大特征(ACID)


## 原子性(Atomicity)
	事务包含的所有操作要么全部成功，要么全部失败回滚。
	因此事务的操作如果成功就必须要完全应用到数据，如果操作失败则不能对数据库有任何影响。

## 一致性(Consistency)
	一致性是指事务必须是数据库从一个一致性状态变换到另一个一致性状态。（所有人的总金额总和不变）
	也就是说一个事务执行之前和执行之后都必须处于一致性状态。

## 隔离性(isolcation) (并发)
	隔离性是当多个用户并发访问数据库时，比如操作同一张表时，数据库为每一个用户开启的事务。
	不能被其它事务的惨状所干扰，多个并发事务之间要相互隔离。

## 持久性 (durability)
	持久性是指一个事务一旦被提交了，那么对数据库中的数据改变就是永久性的。
	即便是在数据库系统遇到故障的情况下也不好会丢失提交事务的操作。


## 事务的隔离级别

注意： 级别越来越高  效率也是越来越低

| 隔离级别         | 名称     | 会引发的问题           |      |
| ---------------- | -------- | ---------------------- | ---- |
| READ UNCOMMITTED | 读未提交 | 脏读、不可重复读、幻读 |      |
| READ commiteed   | 读已提交 | 不可重复读、幻读       |      |
| REPEATABLE READ  | 可重复读 | 幻读                   |      |
| SERIALIZABLE     | 串行化   | 无                     |      |



## 引发的问题

| 问题       | 现象                                                         |
| ---------- | ------------------------------------------------------------ |
| 脏读       | 在一个事务处理过程中读取到了另一个未提交事务中的数据，导致两次查询结果不一致 |
| 不可重复读 | 在一个事务处理过程中读取到了另一个事务中 **修改并已提交** 的数据，导致两次查询的结果不一致 |
| 幻读       | 1- 查询某数据不存在，准备 **插入** 次记录，但执行 **插入** 式发现此记录已存在，无法  **插入**<br>2- 查询数据不存在， 准备 **删除** 操作，却发现删除成功。 |



## 查询事务的隔离级别

SELECT @@TX_ISOLATION;

## 修改数据库的隔离级别   修改后需要重新连接才能查询

SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;

SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT @@autocommit;