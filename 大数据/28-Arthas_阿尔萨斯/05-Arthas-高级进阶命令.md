# 高级进阶命令

## 1- monitor

## 2- trace

## 3- stack

## 4- tt

## 5- options

## 6- profiler火焰图

| profiler命令                | profiler名字作用                   |
| --------------------------- | ---------------------------------- |
| profiler start              | 启动profiler, 默认生成CPU 的火焰图 |
| profiler list               | 显示所有支持的事件                 |
| profiler status             | 查看profiler的状态，运行的时间     |
| profiler getSamples         | 获取已经采集的sample的数量         |
| profiler stop               | 停止profiler 默认格式svg           |
| profiler stop --format html | 指定输出目录和输出格式             |
|                             |                                    |



## 7- 总结

| 命令     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| monitor  | 观察到指定方法的调用情况                                     |
| trace    | 对方法内部调用路径进行追踪，并输出方法路径上的每个节点上耗时 |
| stack    | 输出当前方法被调用的调用路径                                 |
| tt       | 记录下指定方法每次调用的入参和返回信息，并能对这些不同时间下调用的信息 进行观测 |
| options  | 全局开关                                                     |
| profiler | 生成火焰图                                                   |

