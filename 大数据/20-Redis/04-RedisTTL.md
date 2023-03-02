# Redis TTL

## 为什么要设置key的ttl

- 设置key的生存时间，可以用于以下使用场景：
  - 在登录网站后，将用户session存储在内存，设置一个过期时间，超过这个时间后，用户必须重新登录（例如aws控制台的session过期时间为12个小时）。
  - 使用redis队列时，通常设置一个过期时间，这样即使队列的消费者应用出bug，队列内的消息也不会积压。

## 设置key的生存时间

- 通常有两种方式：

  - 在set key时指定生存时间。

  ``` shell
  127.0.0.1:6379> set hello world EX 10
  OK
  127.0.0.1:6379> ttl hello
  (integer) 6
  
  ```

  - set完key后再指定生存时间。使用`expire命令` 

  ``` shell
  127.0.0.1:6379> set key1 val1
  OK
  127.0.0.1:6379> expire key1 10
  (integer) 1
  127.0.0.1:6379> ttl key1
  (integer) 7
  ```

  

## key的生存时间

- 使用TTL key可以访问key的生存时间。
  - 时间复杂度：
    - O(1)

- 返回值：

  - 当 key 不存在时，返回 -2 ;
  - 当 key 存在但没有设置剩余生存时间时，返回 -1 ;
  - 否则，以秒为单位，返回 key 的剩余生存时间;

  ``` shell
  127.0.0.1:6379> ttl xxx            # key不存在，返回-2
  (integer) -2
  127.0.0.1:6379> set newkey newval  # key存在但没有设置生存时间，返回 -1
  OK
  127.0.0.1:6379> ttl newkey
  (integer) -1
  ```

## 清除生存时间

- 已经设置生存时间的key，如果想清除掉生存时间，将其变成永久存在的key，可以使用persist命令。

- 返回值：

  - **1** :  if the timeout was removed.
  - **0** :  if key does not exist or does not have an associated timeout.

  ``` shell
  redis> SET mykey "Hello"
  "OK"
  redis> EXPIRE mykey 10
  (integer) 1
  redis> TTL mykey
  (integer) 10
  redis> PERSIST mykey
  (integer) 1
  redis> TTL mykey
  (integer) -1
  ```

  

## 毫秒级时间

- 以上所有命令时间单位都是秒，如果想设置、访问毫秒级别的时间，在所有命令前加p就可以了。
  - pttl
  - pexpire
  - set key val **px** 10000

``` shell

127.0.0.1:6379> set hello world px 1000000  # 设置1000000毫秒生存时间
OK
127.0.0.1:6379> pttl hello                  # 访问hello的生存时间（毫秒）
(integer) 992975
127.0.0.1:6379> pexpire hello 100000        # 设置hello的生存时间（毫秒）
(integer) 1
```



## 设置TTL代码

``` java

public void saveRedis(String key, String value, Long expireSecond) {
    boolean keyExist = jedisCluster.exists(key);
    // NX是不存在时才set， XX是存在时才set， EX是秒，PX是毫秒
    if (keyExist) {
        jedisCluster.del(key);
    }
    jedisCluster.set(key, value, "NX", "EX", expireSecond);
}
```

