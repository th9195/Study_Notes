# 1- 导入jar包

``` properties
<properties>
    <httpclient.version>4.5.5</httpclient.version>
    <slf4j.version>1.7.25</slf4j.version>
    <fastjson.version>1.2.47</fastjson.version>
</properties>

<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
    <version>${httpclient.version}</version>
</dependency>
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>${slf4j.version}</version>
</dependency>
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>${fastjson.version}</version>
</dependency>
```

# 2- httpclient公共类 

``` java
package com.howdy.callapi.common;


import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sun.istack.internal.logging.Logger;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.config.ConnectionConfig;
import org.apache.http.config.SocketConfig;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.util.EntityUtils;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.nio.charset.Charset;
import java.util.Map;


@Service
public  class HttpUtil {

    private static Logger logger = Logger.getLogger(HttpUtil.class);

    private static CloseableHttpClient httpClient = null;

    private static final Charset CHAR_SET = Charset.forName("utf-8");
    private static PoolingHttpClientConnectionManager cm;
    public  HttpUtil(){
        init();
    }

    public void init() {
        cm = new PoolingHttpClientConnectionManager();
        //设置最大连接数
        cm.setMaxTotal(300);
        //设置每个主机地址的并发数
//        cm.setDefaultMaxPerRoute(100);
        cm.setDefaultConnectionConfig(ConnectionConfig.custom()
                .setCharset(CHAR_SET).build());
        SocketConfig socketConfig = SocketConfig.custom().setSoTimeout(30000)
                .setSoReuseAddress(true).build();
        cm.setDefaultSocketConfig(socketConfig);
        httpClient = HttpClientBuilder.create().setConnectionManager(cm)
                .build();
    }


    public  CloseableHttpClient getHttpClient() {

        int timeout=5;
        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(timeout * 1000) //设置连接超时时间，单位毫秒
                //.setConnectionRequestTimeout(timeout * 1000) //设置从connect Manager获取Connection 超时时间，单位毫秒
                .setSocketTimeout(timeout * 1000).build(); //请求获取数据的超时时间，单位毫秒
        CloseableHttpClient _httpClient = HttpClients.custom()
                .setConnectionManager(cm)
//                .setDefaultRequestConfig(config) //使用此方法连接池会关闭
                .setConnectionManagerShared(true)
                .build();
        if(cm!=null&&cm.getTotalStats()!=null) { //打印连接池的状态
            logger.info("now client pool {}"+cm.getTotalStats().toString());
        }
        return _httpClient;
    }

    /**
     * get请求
     *
     * @return
     */
    public   String doGet(String url) {
        try {
            HttpClient client = getHttpClient();
            //发送get请求
            HttpGet request = new HttpGet(url);
            HttpResponse response = client.execute(request);

            /**请求发送成功，并得到响应**/
            if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
                /**读取服务器返回过来的json字符串数据**/
                String strResult = EntityUtils.toString(response.getEntity());
                request.releaseConnection();
                return strResult;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * post请求 参数为map格式
     *
     * @param url
     * @param params
     * @return
     */
    public  String doPost(String url, Map params) {

        BufferedReader in = null;
        try {
            // 定义HttpClient
            CloseableHttpClient client =getHttpClient();

            // 实例化HTTP方法
            HttpPost request = new HttpPost();
            request.setURI(new URI(url));
            request.setHeader("Content-Type","application/json; charset=utf-8");
            StringEntity s = new StringEntity(JSON.toJSONString(params));
            request.setEntity(s);
            HttpResponse response = client.execute(request);
            int code = response.getStatusLine().getStatusCode();
            if (code == 200) {
                //返回json格式
                String res = EntityUtils.toString(response.getEntity());
                request.releaseConnection();
                return res;
            } else {    //
                System.out.println("状态码：" + code);
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    /**
     * 以post方式  请求参数为json格式
     * @param url
     * @param json
     * @return
     */
    public  String doPost(String url, JSONObject json){
        HttpPost post = new HttpPost(url);
        try {
            if (httpClient == null){
               // httpClient = HttpClientBuilder.create().build();
                httpClient= HttpClients.custom().setConnectionManager(cm).setConnectionManagerShared(true).build();
            }
            httpClient=getHttpClient();
            //api_gateway_auth_token自定义header头，用于token验证使用
           //  post.addHeader("api_gateway_auth_token", tokenString);
            post.addHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.81 Safari/537.36");
            post.setHeader("Content-type", "application/json;charset=utf-8");
            post.setHeader("Connection", "Close");
            StringEntity s = new StringEntity(json.toString());
            s.setContentEncoding("UTF-8");
            //发送json数据需要设置contentType
            s.setContentType("application/x-www-form-urlencoded");
            //设置请求参数
            post.setEntity(s);
            HttpResponse response = httpClient.execute(post);

            if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK){
                //返回json格式
                String res = EntityUtils.toString(response.getEntity());
                post.releaseConnection();
                return res;
            }
        } catch (Exception e) {
            logger.info("excep:"+e.getMessage());
            e.printStackTrace();
        }finally {
            if (post != null)
                post.releaseConnection();
            if (httpClient != null){
                try {
                    httpClient.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
        return null;
    }
}
```



# 3- controller调用 

``` java
package com.howdy.callapi.controller;


import com.alibaba.fastjson.JSONObject;
import com.howdy.callapi.common.HttpUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/callapi")
public class CallController {

    @Autowired
   private HttpUtil httpUtil;


    @GetMapping("/getdetail")
    public String getdetail(){
        String result= httpUtil.doGet("https://***/ById?id=3");
        System.out.println(result);
        return  result;
    }

    @PostMapping("/getlist")
    public String getlist(){
        HttpUtil util=new HttpUtil();
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("pageIndex",1);
        jsonObject.put("pageCount",10);
           jsonObject.put("start_time","");
        jsonObject.put("end_time","");
        String result= httpUtil.doPost("https://***/GetMen",jsonObject);
        System.out.println("jsonobject:"+result);

        return  result;
    }

    @PostMapping("/getlist2")
    public String getlist2(){

        Map params=new HashMap<>();
        params.put("pageIndex",1);
        params.put("pageCount",10);
        params.put("start_time","");
        params.put("end_time","");
        String result2= httpUtil.doPost(https://***/GetMen",params);
        System.out.println("jsonobject2:"+result2);
        return  result2;
    }
}
```

