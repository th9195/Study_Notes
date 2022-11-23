# 1-Driver

- 通过CDH 找到对应Job执行的 applicationId , 点击右键 使用新界面打开；

![image-20220930161616727](images/image-20220930161616727.png)

- 点击 logs

![image-20220930161829656](images/image-20220930161829656.png)

- 点击 here

![image-20220930161917939](images/image-20220930161917939.png)







# 2- executor

- yarn logs -applicationId    xxxxxx
  - 通过CDH 找到该任务的 applicationID

![image-20220930162331200](images/image-20220930162331200.png)

``` shell
yarn logs -applicationId application_1654136630530_0665  > totalLog.log
```



