#                             数仓建设

## UDF函数开发

### 添加hive UDF流程

```
1.继承hive UDF实现evaluate 方法

2.add JAR /opt/flinkJar/spark_data_statistics.jar;


3.测试过程中创建的临时函数
  create temporary function decrypt as 'com.df.bigdata.analysis.udfs.ZhwDecryptUDF';
  create temporary function encrypt as 'com.df.bigdata.analysis.udfs.ZhwEncryptUDF';     
  create temporary function desensitive as 'com.df.bigdata.analysis.udfs.ZhwDesensitiveUDF';
  create temporary function idCardCheck as 'com.df.bigdata.analysis.udfs.ZhwIdCardUDF';
  create temporary function mobilePhoneCheck as 'com.df.bigdata.analysis.udfs.ZhwMobilePhoneUDF';
  create temporary function emailCheck as 'com.df.bigdata.analysis.udfs.ZhwEmailUDF';
  create temporary function ipCheck as 'com.df.bigdata.analysis.udfs.ZhwIpParseUDF';
  create temporary function emojiCheck as 'com.df.bigdata.analysis.udfs.ZhwEmojiUDF'
  
4.select encrypt('183367','0102030405060708')                   =>          tMzLUZrPEswGi+xunlUViQ==;
  select decrypt('tMzLUZrPEswGi+xunlUViQ==','0102030405060708') =>          0102030405060708;
  select desensitive('18336720248',3,3)                         =>          183*****248;
  select idCardCheck("321083197812162119","AGE")                =>          42;
  select mobilePhoneCheck("18336720248")                        =>          true;
  select emailCheck("1356709961@qq.com")                        =>          true;
  select ipCheck('112.126.60.145','country')                    =>          中国;
  select emojiCheck('xxxx😠')                                   =>          xxxx;
```

### 函数使用说明

```
1.加密函数encrypt
  函数： encrypt(String param1,String param2)
  参数： param1:需要加密的数据 param2:秘钥(128/192/256 bits 即16、24、32位)
  返回值：String
  用例：select encrypt("18336720248","1111111111111111") from table 
  结果：1eNiGTRueP/L+lXjpZjH3g==
  异常情况说明：当秘钥位数不对时  返回源数据,当其中参数为null时 返回null
  
2.解密函数decrypt
  函数：decrypt(String param1,String param2)
  参数：param1:需要解密的数据 param2:加密时的秘钥(128/192/256 bits 即16、24、32位)
  返回值：String
  用例：select encrypt("18336720248","1111111111111111") from table
  结果：1eNiGTRueP/L+lXjpZjH3g==
  异常情况说明：当秘钥位数不对时  返回源数据,当其中参数为null时 返回null
  
3.脱敏函数desensitive
  函数：desensitive(String param1,Int param2,Int param3)
  参数：param1:需要脱敏的字符串 param2:从左边起第几位开始脱敏(索引位) param3：到右边第几位结束脱敏(索引位)
  返回值：String
  用例：select desensitive('18336720248',3,3) from table
  结果：183*****248
  异常情况说明：当输入的索引位是负数时，返回源数据,当其中参数为null时 返回null
  
4.身份证校验解析函数idCardCheck
  函数：1 desensitive(String param1)(校验身份证) || 2 desensitive(String param1,String param2)(解析身份证)
  参数：1-param1：身份证号 2-param1：身份证号 2-param2：解析类型 解析生日、年龄、性别、省份、身份证15转18位
  返回值：1-Boolean 2-String
  用例：select idCardCheck("321083197812162119") from table              => true
       select idCardCheck("150102880730303","CONVERT15TO18") from table => 150102198807303035
       select idCardCheck("321083197812162119","BIRTHDAY") from table   => 19781216
       select idCardCheck("321083197812162119","AGE") from table        => 42
       select idCardCheck("321083197812162119","GENDER") from table     => 1
       select idCardCheck("321083197812162119","PROVINCE") from table   => 江苏
       参数2大小写均可
  异常情况说明：当传入的类型参数异常时  返回源数据,当其中参数为null时 返回null
  
5.手机号校验函数mobilePhoneCheck
  函数：mobilePhoneCheck(Int param1)
  参数：param1：手机号
  返回值：Boolean
  用例：select mobilePhoneCheck(18336720248) from table
  结果：ture
  异常情况说明:参数为null 返回null
  
6.邮箱校验函数emailCheck
  函数：emailCheck(String param1)
  参数：param1：邮箱号
  返回值：Boolean
  用例：select emailCheck("1356709961@qq.com") from table
  结果：true
  异常情况说明:参数为null 返回null
  
7.ip解析函数ipCheck
  函数：ipCheck(String param1,String param2)
  参数：param1：ip param2：country（国家）、province（省份）、city（城市）、isp（网络运营商）
  返回值：String
  用例：select ipCheck('112.126.60.145','country') from table    
       select ipCheck('112.126.60.145','province') from table
       select ipCheck('112.126.60.145','city') from table
       select ipCheck('112.126.60.145','isp') from table
  异常情况说明:参数为null、异常ip 返回null,未被收录的ip 返回0 
  
8.Emoji解析函数emojiCheck
  函数：emojiCheck(String param1)
  参数：param1：带有emoji表情的字符串
  返回值：String 去除表情的字符串
  用例：select emojiCheck("xxxx😠") from table
  结果：xxxx
  异常情况说明:参数为null 返回null
  
```



### 加密函数(Encrypt)

```java
#加密函数Encrypt AES加密 对称加密
package com.df.bigdata.analysis.udfs;

import cn.hutool.core.util.CharsetUtil;
import cn.hutool.crypto.symmetric.SymmetricAlgorithm;
import cn.hutool.crypto.symmetric.SymmetricCrypto;
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.log4j.Logger;

/**
 * @version 1.0
 * @author: gxj
 * @desc: 采用AES加密方式(对称加密)
 *   使用方式：encrypt("需要加密的数据","秘钥(128/192/256 bits 即16、24、32位)")
 *   用例：select encrypt("18336720248","1111111111111111") from table
 *   结果：1eNiGTRueP/L+lXjpZjH3g==
 *   异常情况说明：当秘钥位数不对时  返回源数据
 * @date: 2021/9/13 15:10
 **/
public class ZhwEncryptUDF extends UDF {

    private static final Logger logger = Logger.getLogger(ZhwEncryptUDF.class);

    /**
     * @param data 需要加密的数据
     * @param key  加密秘钥
     * @return 返回加密后的字符串
     * @throws Exception
     */
    public String evaluate(String data, String key) {

        if(data == null || key == null){
            logger.error("parameter is incorrect");
            return null;
        }


        //秘钥key必须是 128/192/256 bits
        if (key.length() != 16 && key.length() != 24 && key.length() != 32) {
            logger.info("Key length not 128/192/256 bits");
            return data;
        }

        //构造密钥生成器，指定AES算法
        try {
            byte[] keyBytes = key.getBytes();

            //构建
            SymmetricCrypto aes = new SymmetricCrypto(SymmetricAlgorithm.AES, keyBytes);

            //加密
            String encryData = aes.encryptBase64(data, CharsetUtil.CHARSET_UTF_8);

            return encryData;
        } catch (Exception e) {
            logger.error("Parsing exception:" + e.getMessage());
        }
        return data;
    }
}



```

### 解密函数（Decrypt）

```java
#解密函数Decrypt
package com.df.bigdata.analysis.udfs;

import cn.hutool.core.util.CharsetUtil;
import cn.hutool.crypto.symmetric.SymmetricAlgorithm;
import cn.hutool.crypto.symmetric.SymmetricCrypto;
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.log4j.Logger;

/**
 * @version 1.0
 * @author: gxj
 * @desc: 采用AES解密方式(对称加密)
 *    使用说明：decrypt("需要解密的数据","秘钥(128/192/256 bits 即16、24、32位)")
 *    用例：select decrypt("1eNiGTRueP/L+lXjpZjH3g==","1111111111111111") from table
 *    结果：18336720248
 *    异常情况说明：当秘钥位数不对时  返回源数据
 * @date: 2021/9/13 15:10
 **/
public class ZhwDecryptUDF extends UDF {

    private static final Logger logger = Logger.getLogger(ZhwDecryptUDF.class);

    /**
     * @param data 需要解密的数据
     * @param key  解密秘钥
     * @return 返回解密后的字符串
     * @throws Exception
     */
    public String evaluate(String data, String key) {
        if(data == null || key == null){
            logger.error("parameter is incorrect");
            return null;
        }

        if (key.length() != 16 && key.length() != 24 && key.length() != 32) {
            return "Key length not 128/192/256 bits";
        }
        //构造密钥生成器，指定AES算法
        try {
            byte[] keyBytes = key.getBytes();

            //构建
            SymmetricCrypto aes = new SymmetricCrypto(SymmetricAlgorithm.AES, keyBytes);

            //解密
            String decryptData = aes.decryptStr(data, CharsetUtil.CHARSET_UTF_8);

            return decryptData;
        } catch (Exception e) {
            logger.error("Parsing exception:" + e.getMessage());
        }
        return data;
    }
}



```

### 脱敏函数（Desensitive）

```java
#脱敏函数Desensitive

package com.df.bigdata.analysis.udfs;

import cn.hutool.core.util.DesensitizedUtil;
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.log4j.Logger;

/**
 * @version 1.0
 * @author: gxj
 * @desc: 数据脱敏
 *   使用说明：desensitive(数据，从左边起第几位开始脱敏(索引位),到右边第几位结束脱敏(索引位))
 *   用例：select desensitive('18336720248',3,3) from table
 *   结果： 183*****248
 *   异常情况说明：当输入的索引位是负数时，返回源数据
 * @date: 202d1/9/14 11:51
 **/
public class ZhwDesensitiveUDF extends UDF {
    private static final Logger logger = Logger.getLogger(ZhwDesensitiveUDF.class);

    /**
     * @param data  需要脱敏的数据
     * @param front 从左边起第几位开始脱敏
     * @param end   到右边第几位结束脱敏
     * @return 托名后的数据
     */
    public String evaluate(String data, Integer front, Integer end) {
        if(data == null || front == null || end == null){
            logger.error("parameter is incorrect");
            return null;
        }
        if(front < 0 || end < 0){
            logger.error("Indexes Parameter must be greater than or equal to 0");
            return data;
        }

        String DesensitiveData = DesensitizedUtil.idCardNum(data, front, end);

        return DesensitiveData;
    }
}

    

```

### 身份证校验、解析函数（IdCardChcek）

```java
#身份证校验函数IdCard
package com.df.bigdata.analysis.udfs;

import cn.hutool.core.util.IdcardUtil;
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.log4j.Logger;

/**
 * @version 1.0
 * @author: gxj
 * @desc: 使用方式：idCardCheck("身份证号") 或者 idCard("身份证号","解析类型")
 *   用例：select idCardCheck("321083197812162119","AGE") from table
 *   结果：42
 *   异常情况说明：当传入的类型参数异常时  返回源数据
 * @date: 2021/9/14 15:38
 **/
public class ZhwIdCardUDF extends UDF {

    private static final Logger logger = Logger.getLogger(ZhwIdCardUDF.class);
    private static final String CONVERT15TO18 = "CONVERT15TO18";
    private static final String BIRTHBYIDCARD = "BIRTHDAY";
    private static final String AGEBYIDCARD = "AGE";
    private static final String GENDERBYIDCARD = "GENDER";
    private static final String PROVINCEBYIDCARD = "PROVINCE";

    /**
     * 身份证校验
     *
     * @param data 省份正号(15、18未都可以)
     * @return 是否是合格的身份证号
     */
    public Boolean evaluate(String data) {
        if(data == null){
            logger.error("parameter is incorrect");
            return null ;
        }

        boolean validCard = IdcardUtil.isValidCard(data);

        return validCard;
    }

    /**
     * 解析身份证号
     *
     * @param data 身份证号(15、18未都可以)
     * @param type 解析生日、年龄、性别、省份、身份证15转18位
     * @return 解析后的数据
     */
    public String evaluate(String data, String type) {
        if (type.equals(CONVERT15TO18) || type.equals(data.toLowerCase())) {
            return IdcardUtil.convert15To18(data);
        } else if (type.equals(BIRTHBYIDCARD) || type.equals(BIRTHBYIDCARD)) {
            return IdcardUtil.getBirthByIdCard(data);
        } else if (type.equals(AGEBYIDCARD) || type.equals(AGEBYIDCARD)) {
            return String.valueOf(IdcardUtil.getAgeByIdCard(data));
        } else if (type.equals(GENDERBYIDCARD) || type.equals(GENDERBYIDCARD)) {
            return String.valueOf(IdcardUtil.getGenderByIdCard(data));
        } else if (type.equals(PROVINCEBYIDCARD) || type.equals(PROVINCEBYIDCARD)) {
            return IdcardUtil.getProvinceByIdCard(data);
        } else {
            logger.error("Parameter input error,Only CONVERT15TO18,BIRTHDAY,AGE,GENDER,PROVINCE");
            return data;
        }
    }
}


```

### 手机号校验函数（MobilePhoneCheck）

```java
#手机号校验函数MobilePhoneCheck
package com.df.bigdata.analysis.udfs;

import cn.hutool.core.util.ReUtil;
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.log4j.Logger;

/**
 * @version 1.0
 * @author: gxj
 * @desc: 手机号校验
 * 用例：select mobilePhoneCheck(18336720248) from table
 * 结果：true
 * @date: 2021/9/14 17:28
 **/
public class ZhwMobilePhoneUDF extends UDF {
    private static final Logger logger = Logger.getLogger(ZhwMobilePhoneUDF.class);

    /**
     * 验证手机号码
     * 移动号码段:139、138、137、136、135、134、150、151、152、157、158、159、182、183、187、188、147
     * 联通号码段:130、131、132、136、185、186、145
     * 电信号码段:133、153、180、189
     *
     * @param data 手机号
     * @return 是否正常
     */
    public Boolean evaluate(Integer data) {
        if (data == null) {
            logger.error("Please enter parameters");
            return null;
        }

        Boolean isPhoneNum = ReUtil.isMatch("^((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(18[0,2-3]|[5-9]))\\d{8}$", String.valueOf(data));

        return isPhoneNum;
    }
}


```

### 邮箱校验函数（EmailCheck）

```java
#邮箱校验函数EmailCheck

package com.df.bigdata.analysis.udfs;

import cn.hutool.core.util.ReUtil;
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.log4j.Logger;

/**
 * @version 1.0
 * @author: gxj
 * @desc: 邮箱号校验
 * 用例：select emailCheck("1356709961@qq.com") from table
 * 结果：true
 * @date: 2021/9/15 09:28
 **/
public class ZhwEmailUDF extends UDF {

    private static final Logger logger = Logger.getLogger(ZhwEmailUDF.class);
    /**
     * 邮箱校验
     * 新浪：4-16个字符，可使用英文小写、数字、下划线，下划线不能在首尾。
     * 搜狐：4-16位，数字、小写字母、点、减号或下划线，小写字母开头。
     * 腾讯：由3-18个英文、数字、点、减号、下划线组成。
     * 网易：6~18个字符，可使用字母、数字、下划线，需以字母开头。
     * 谷歌：您可以使用字母、数字和英文句点，请勿使用除字母 (a-z)、数字和英文句号外的其他字符。
     * 央视：6~20个字符，包括英文字母（小写）数字-_,首尾字符须为字母或数字，且邮箱名不能为纯数字。
     * TOM:  6-18个字符，仅支持字母、数字及“.”、”-”、”_”，不能全部数字或下划线
     *
     *得出通用的邮箱标准： 长度不限，可以使用英文（包括大小写）、数字、点号、下划线、减号，首字母必须是字母或数字；
     *
     * @param data 邮箱号
     * @return 是否正常
     */
    public Boolean evaluate(String data) {

        if (data == null) {
            logger.error("Please enter parameters");
            return false;
        }

        Boolean isEmailNum = ReUtil.isMatch("^[a-z0-9A-Z]+[- | a-z0-9A-Z . _]+@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-z]{2,}$", data);

        return isEmailNum;
    }
}



```

### IP解析函数（IpCheck）

```java
#ip 解析函数 
package com.df.bigdata.analysis.udfs;

import com.df.bigdata.analysis.utils.Commons;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.log4j.Logger;
import org.lionsoul.ip2region.DbConfig;
import org.lionsoul.ip2region.DbSearcher;
import org.lionsoul.ip2region.Util;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URI;

/**
 * @version 1.0
 * @author: gxj
 * @desc: 自定义函数-IP定位
 *   IP 定位依赖于网络开源的 IP 数据库，如无必要，不会频繁更新，预计每半年更新一次，如果查询返回值为 0 ，说明 IP 位置信息未收录
 *   函数使用说明: ipCheck(ip, mode)
 *   参数说明：
 *     - mode，查询模式，字符串类型，支持参数：country（国家）、province（省份）、city（城市）、isp（网络运营商）
 *     - ip，IP 地址，字符串类型，格式如：xxx.xxx.xxx.xxx
 *   返回值类型：字符串
 *   查询实例：
 *   select
 *      ipCheck('country','112.126.60.145') "国家",
 *      ipCheck('province','112.126.60.145') "省份",
 *      ipCheck('city','112.126.60.145') "城市",
 *      ipCheck('isp','112.126.60.145') "网络运营商",
 *      ipCheck('city','112.'), -- 非正常 IP ，返回null
 *      ipCheck('city',null), -- IP 值为 null ，返回null
 *      ipCheck('city','36.98.202.245') -- 返回值为 0 ，说明未收录该 IP 该项位置信息
 * @date: 2021/9/15 09:28
 **/
public class ZhwIpParseUDF extends UDF {
    private static final Logger logger = Logger.getLogger(ZhwIpParseUDF.class);

    private static DbSearcher SEARCHER;
    private static final int LOCATIONS = 5;
    private static final String DB_FILE = "hdfs://nameservice1/data/udf/ip2region.db";

    static {
        try {
            Configuration configuration = Commons.getClusterConf();
            FileSystem fileSystem = FileSystem.get(URI.create(DB_FILE), configuration);
            InputStream in = fileSystem.open(new Path(DB_FILE));
            ByteArrayOutputStream out;
            out = new ByteArrayOutputStream();
            byte[] b = new byte[1024];
            while (in.read(b) != -1) {
                out.write(b);
            }
            byte[] data = out.toByteArray();
            DbConfig config = new DbConfig();
            SEARCHER = new DbSearcher(config, data);
            out.close();
            in.close();
        } catch (Exception e) {
            logger.error("ip2region config init failed:"+e.getMessage());
        }
    }

    /**
     *
     * @param data ip
     * @param mode country、province、city、isp
     * @return
     * @throws Exception
     */
    public String evaluate(String data, String mode) throws Exception {

        if (data == null) {
            return null;
        }
        String locations;
        if (Util.isIpAddress(data)) {
            try {
                locations = SEARCHER.memorySearch(data).getRegion();
            } catch (Exception e) {
                return null;
            }
        } else {
            return null;
        }

        String[] res = locations.split("\\|");
        if (res.length < LOCATIONS) {
            return locations;
        }
        String result;
        switch (mode) {
            case "country" :
                result = res[0];
                break;
            case "province":
                result = res[2];
                break;
            case "city":
                result = res[3];
                break;
            case "isp":
                result = res[4];
                break;
            default:
                throw new Exception("Invalid arguments, the param1 could be: country, province, city, isp.");
        }
        return result;
    }
}


```

### Emoji解析函数(EmojiCheck)

```
#Emoj解析函数 EmojiCheck
package com.df.bigdata.analysis.udfs;

import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.log4j.Logger;

/**
 * @version 1.0
 * @author: gxj
 * @desc: Emoji解析函数
 * 用例：select emojiCheck("xxxx😠") from table
 * 结果：xxxx
 * @date: 2021/9/15 15:52
 **/
public class ZhwEmojiUDF extends UDF {

    private static final Logger logger = Logger.getLogger(ZhwEmojiUDF.class);

    /**
     * Emoji
     *
     * @param data 带有表情的字符串
     * @return 去除表情字符
     */
    public String evaluate(String data) {

        if (data == null) {
            logger.error("Please enter parameters");
            return null;
        }

        StringBuffer out = new StringBuffer();

        char[] chars = data.toCharArray();

        for (int i = 0; i < chars.length; i++) {
            if ((chars[i] >= 19968 && chars[i] <= 40869)         //中日朝兼容形式的unicode编码范围： U+4E00——U+9FA5
                    || (chars[i] >= 11904 && chars[i] <= 42191) //中日朝兼容形式扩展
                    || (chars[i] >= 63744 && chars[i] <= 64255) //中日朝兼容形式扩展
                    || (chars[i] >= 65072 && chars[i] <= 65103) //中日朝兼容形式扩展
                    || (chars[i] >= 65280 && chars[i] <= 65519) //全角ASCII、全角中英文标点、半宽片假名、半宽平假名、半宽韩文字母的unicode编码范围：U+FF00——U+FFEF
                    || (chars[i] >= 32 && chars[i] <= 126)      //半角字符的unicode编码范围：U+0020-U+007e
                    || (chars[i] >= 12289 && chars[i] <= 12319)//全角字符的unicode编码范围：U+3000——U+301F
            ) {
                out.append(chars[i]);
            }
        }

        String result = out.toString().trim();
        result = result.replaceAll("\\?", "").replaceAll("\\*", "").replaceAll("<|>", "").replaceAll("\\|", "").replaceAll("/", "");
        return result;
    }
}

```

