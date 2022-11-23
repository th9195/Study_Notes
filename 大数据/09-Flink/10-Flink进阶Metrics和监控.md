



- **Metrics** 可以在 Flink 内部**[收集一些指标]()**;

- 通过这些指标让开发人员更好地理解作业或[**集群的状态**]();

- 也可以整合第三方工具对Flink进行监控；

  - 如：**[普罗米修斯 和 Grafana 监控Flink运行状态]()**

- Metrics 的类型

  - 1，常用的如 **[Counter]()**，写过 mapreduce 作业的开发人员就应该很熟悉 Counter，其实含义都是一样的，就是对一个计数器进行累加，即对于多条数据和多兆数据一直往上加的过程。
  - 2，**[Gauge]()**，Gauge 是最简单的 Metrics，它反映一个值。比如要看现在 [**Java heap 内存**]()用了多少，就可以每次实时的暴露一个 Gauge，Gauge 当前的值就是heap使用的量。
  - 3，[**Meter**]()，Meter 是指统计吞吐量和单位时间内发生[**“事件”的次数**]()。它相当于求一种速率，即[事件次数除以使用的时间]()。
  - 4，[**Histogram**]()，Histogram 比较复杂，也并不常用，Histogram 用于统计一些数据的分布，比如说 Quantile、Mean、StdDev、Max、Min 等。

   

  Metric 在 Flink 内部有多层结构，以 Group 的方式组织，它并不是一个扁平化的结构，Metric Group + Metric Name 是 Metrics 的唯一标识。

![image-20210624182646549](images/image-20210624182646549.png)