# Jmap

## 1- 作用

- 生成java程序的dump文件；
- 查看堆内对象信息；
- 查看Classloader的信息；
- 查看finalizer队列；

## 2- 命令格式

- jmap [options] <pid>

## 3- 参数解释

- no option : 查看进程的内存映像信息， 类似Solaris pMap 命令；
- heap : 显示java堆详细信息；
- histo[:live] : 显示堆中对象的统计信息；
- clstats : 打印类加载器信息；
- finalizerinfo : 显示在F-Queue队列等待Finalizer线程执行finalizer方法的对象；
- dump:<dump-options> : 生成堆转储快照；

## 4- 命令演示

- jmap pid

  - 查看进程的内存映像信息；
  - 使用不带选项参数的jmap 打印共享对象映射，将会打印目标虚拟机中加载的每个共享对象的起始地址，映射大小以及共享对象文件的路径全程；

- jmap -heap pid

  - 显示java 堆详情信息；
  - 打印一个堆的摘要信息，包括使用的GC算法，堆配置信息和各内存区域内存使用信息；

  ``` properties
  PS C:\work\codes\main_fab_flink\MainFabFlinkJob> jmap -heap 1896
  Attaching to process ID 1896, please wait...
  Debugger attached successfully.
  Server compiler detected.
  JVM version is 25.102-b14
  
  using thread-local object allocation.
  Parallel GC with 10 thread(s)
  
  Heap Configuration:
     MinHeapFreeRatio         = 0
     MaxHeapFreeRatio         = 100
     MaxHeapSize              = 3980394496 (3796.0MB)
     NewSize                  = 82837504 (79.0MB)
     MaxNewSize               = 1326448640 (1265.0MB)
     OldSize                  = 166723584 (159.0MB)
     NewRatio                 = 2
     SurvivorRatio            = 8
     MetaspaceSize            = 21807104 (20.796875MB)
     CompressedClassSpaceSize = 1073741824 (1024.0MB)
     MaxMetaspaceSize         = 17592186044415 MB
     G1HeapRegionSize         = 0 (0.0MB)
  
  Heap Usage:
  PS Young Generation
  Eden Space:
     capacity = 62914560 (60.0MB)
     used     = 20191448 (19.256065368652344MB)
     free     = 42723112 (40.743934631347656MB)
     32.09344228108724% used
  From Space:
     0.0% used
  PS Old Generation
     capacity = 166723584 (159.0MB)
     used     = 0 (0.0MB)
     free     = 166723584 (159.0MB)
     0.0% used
  
  2229 interned Strings occupying 203152 bytes.
  
  ```

  

- jmap -histo:live  pid

- jmap -histo pid 

  - 显示堆中对象的统计信息；

  - 其中包括每个java类，对象数量，内存大小(单位:字节),完全限定的类名。

  - 打印的虚拟机内部的类名称将会带有一个‘*’ 前缀。

  - 如果指定了live 子选项，则只计算活动的对象；

  - 打印堆的对象统计，包括对象数、内存大小等。jmap -histo:live这个命令执行，**JVM会先触发gc**，然后再统计信息。

    **第一列：编号id** 

    **第二列：实例个数 ** 

    **第三列：所有实例大小** 

    **第四列：类名** 

- jmap -clstats pid

  - 打印类加载器信息；
  - -clstats 是 -permstat 的替代方案，在JDK8之前， -permstat 用来打印类加载器的数据；

  ``` properties
  PS C:\work\codes\main_fab_flink\MainFabFlinkJob> jmap -clstats 1896
  Attaching to process ID 1896, please wait...
  Debugger attached successfully.
  Server compiler detected.
  JVM version is 25.102-b14
  finding class loader instances ..done.
  computing per loader stat ..done.
  please wait.. computing liveness...............done.
  class_loader    classes bytes   parent_loader   alive?  type
  
  <bootstrap>     496     935492    null          live    <internal>
  0x000000077105c730      409     661260  0x0000000770fa06a0      live    sun/misc/Launcher$AppClassLoader@0x00000007c000f6a0
  0x0000000770fa06a0      0       0         null          live    sun/misc/Launcher$ExtClassLoader@0x00000007c000fa48
  
  total = 3       905     1596752     N/A         alive=3, dead=0     N/A
  PS C:\work\codes\main_fab_flink\MainFabFlinkJob> 
  
  ```

  

- jmap -finalizerinfo pid

  - 打印等待终结的对象信息；
  - Number of objects pending for finalization:0 说明当前F-Queue队列中并没有等待Finalizer线程执行finalizer方法的对象；

  ``` properties
  PS C:\work\codes\main_fab_flink\MainFabFlinkJob> jmap -finalizerinfo 1896
  Attaching to process ID 1896, please wait...
  Debugger attached successfully.
  Server compiler detected.
  JVM version is 25.102-b14
  Number of objects pending for finalization: 0   ## 看这里
  PS C:\work\codes\main_fab_flink\MainFabFlinkJob> 
  ```

  

  - jmap -dump:live,format=b,file=/tmp/dump.hprof  13145  
  - **注意：**  -dump:live,format=b,file=/tmp/dump.hprof 这是一个参数 ， 中间没有空格；
  - 生成堆转储快照dump文件；
  - 以二进制格式转储java堆到指定filename的文件中。
  - live子选项是可选的，如果指定了live子选项，堆中只有活动的对象被转储。
  - **想要浏览heap dump ,可以使用jhat** ；

  

  

  

  

  



























