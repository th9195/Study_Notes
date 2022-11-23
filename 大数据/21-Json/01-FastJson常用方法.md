# 1-FastJson介绍

1、遵循http://json.org标准，为其官方网站收录的参考实现之一。

2、功能强大，支持JDK的各种类型，包括基本的**JavaBean、Collection、Map、Date、Enum**、泛型。

3、无依赖，不需要例外额外的jar，能够直接跑在JDK上。

4、开源，使用Apache License 2.0协议开源。http://code.alibabatech.com/wiki/display/FastJSON/Home



# 2- maven(jar) 依赖

```ruby
https://mvnrepository.com/artifact/com.alibaba/fastjson
```



# 3- API文档

``` http
GitHub: https://github.com/alibaba/fastjson/wiki/JSON_API_cn

w3c:https://www.w3cschool.cn/fastjson/fastjson-jsonfield.html
```



# 4- 序列化API

``` java
package com.alibaba.fastjson;

public abstract class JSON {
    // 将Java对象序列化为JSON字符串，支持各种各种Java基本类型和JavaBean
    public static String toJSONString(Object object, SerializerFeature... features);

    // 将Java对象序列化为JSON字符串，返回JSON字符串的utf-8 bytes
    public static byte[] toJSONBytes(Object object, SerializerFeature... features);

    // 将Java对象序列化为JSON字符串，写入到Writer中
    public static void writeJSONString(Writer writer, 
                                       Object object, 
                                       SerializerFeature... features);

    // 将Java对象序列化为JSON字符串，按UTF-8编码写入到OutputStream中
    public static final int writeJSONString(OutputStream os, // 
                                            Object object, // 
                                            SerializerFeature... features);



}
```

# 5- 反序列化

``` java
package com.alibaba.fastjson;

public abstract class JSON {
    // 将JSON字符串反序列化为JavaBean
    public static <T> T parseObject(String jsonStr, 
                                    Class<T> clazz, 
                                    Feature... features);

    // 将JSON字符串反序列化为JavaBean
    public static <T> T parseObject(byte[] jsonBytes,  // UTF-8格式的JSON字符串
                                    Class<T> clazz, 
                                    Feature... features);

    // 将JSON字符串反序列化为泛型类型的JavaBean
    public static <T> T parseObject(String text, 
                                    TypeReference<T> type, 
                                    Feature... features);

    // 将JSON字符串反序列为JSONObject
    public static JSONObject parseObject(String text);
}
```



# 6- 实例

## 6-1 序列化-json字符串 转 json 对象

``` java
JSONObject jsonObject = JSONObject.parseObject(s1);
  
Object id = jsonObject.get("id"); //拿到id
System.out.println(id);//1
System.out.println("json对象转json字符串 "+jsonObject.toJSONString());
```



## 6-2 反序列化-json字符串转成pojo

### 6-2-1 简单

``` scala
User user1 = JSON.parseObject(s1, User.class);
System.out.println(user1.getName());
```

### 6-2-2 复杂 -TypeReference

``` scala
val res = JSON.parseObject(JSON.toJSONString(jsonStr, SerializerFeature.PrettyFormat), classOf[WarehouseEmpBean])
    
val funcBeans: util.ArrayList[FuncBean] = JSON.parseObject(func_json, new TypeReference[util.ArrayList[FuncBean]]() {})
```



``` java
import com.alibaba.fastjson.JSON;

Type type = new TypeReference<List<Model>>() {}.getType(); 
List<Model> list = JSON.parseObject(jsonStr, type);
```





## 6-3 反序列化-json对象获取pojo -TypeReference

``` java
void testTypeReference() {
    List<Integer> list = new ArrayList<>();
    list.add(1);
    list.add(9);
    list.add(4);
    list.add(8);
    JSONObject jsonObj = new JSONObject();
    jsonObj.put("a", list);
    System.out.println(jsonObj); // {"a":[1,9,4,8]}

    List<String> list2 = jsonObj.getObject("a", new TypeReference<List<Integer>>(){});

    System.out.println(list2); // [1, 9, 4, 8]
}
```





## 6-3 反序列化-json字符串 转 list 对象

``` java
List<User> users = JSONArray.parseArray(s1, User.class);
users.forEach(obj-> System.out.println(obj.toString()));
```



## 6-4 list转json字符串

``` java
Object toJSON = JSON.toJSON(list);
System.out.println("list-->jsonStr"+toJSON);

结果:list转json字符串[{"grade":"1班","id":1,"name":"zs"},{"grade":"2班","id":2,"name":"ls"}]
```



## 6-5 json字符串 转 Map

``` java
String str = "{\"1\":\"zs\",\"2\":\"ls\",\"4\":\" ww\",\"5\":\"ml\"}";
//第一种
Map maps = (Map) JSON.parse(str);
System.out.println("第1种");
for (Object obj : maps.keySet()) {
    System.out.println("key：" + obj + "value：" + maps.get(obj));
}

//第二种
Map mapTypes = JSON.parseObject(str);
System.out.println("第2种");
for (Object obj : mapTypes.keySet()) {
    System.out.println("key：" + obj + "value：" + mapTypes.get(obj));
}

//第三种
Map mapType = JSON.parseObject(str, Map.class);
System.out.println("第3种");
for (Object obj : mapType.keySet()) {
    System.out.println("key：" + obj + "value：" + mapTypes.get(obj));
}

//第四种
/**
     * JSONObject是Map接口的一个实现类
     */
Map json = (Map) JSONObject.parse(str);

//第五种
Map jsonMap = (Map) JSONObject.parseObject(str);
```









