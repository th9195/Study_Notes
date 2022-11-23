# Checkpoint 作用



# CheckPoint 流程





# CheckPoint 原理



# CheckPoint 超时原因

1. 可能某个task solt中**<font color='red'>算子报错</font>**，那么这个barrier就永远无法到达，那么checkpoint要想等待barrier对齐，结果是不可能，进而导致checkpoint失败；
2. 某个task solt中算子**<font color='red'>数据倾斜</font>**，等待很长时间;
3. 某个task solt中**<font color='red'>算子和外部存储系统交互时间很长</font>** ;
4. 大状态state的存储;
5. 增加的**<font color='red'>网络缓冲区数量</font>**也导致增加了检查点时间，因为保持更多的飞行中数据意味着检查点障碍被延迟了;
6. 使用异步状态后端 rosckdb;
7. 



# CheckPoint 超时定位

