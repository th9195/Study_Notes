# 1- 前言

​    Conda是Anaconda中一个强大的包和环境管理工具，可以在Windows的Anaconda Prompt命令行使用，也可以在macOS或者Linux系统的终端窗口(terminal window)的命令行使用。

```
本文简单介绍conda的一些常用命令（对于大多数人来说掌握了这些就基本上能够‘生活自理’了吧）命令。当然，本文假定你已经安装了Anaconda，并且在Windows条件下使用Anaconda Prompt或者在Linux下使用terminal window。

本文根据conda-getting-started编译而成，喜欢阅读英文的伙伴们可以直接去读英文说明。

conda命令的一些选项开关有两种指定方式，一种两个连接号“--”后跟选项名全程，一种是一个连接号“-”后跟简称。比如说"-n"和"--name"是等价的。但是要注意有些例外，比如说，“--version”对应的是“-V”（大写的V而不是小写的v）。
```
# 2- 管理conda自身

## 2-0 conda 查看

- 查看conda版本

  ```shell
  conda --version
  ```

  

- 查看conda的环境配置

  ```shell
  conda config --show
  ```

  

- 运行结果示例（只是截取了最前面一小段） 

![img](https://i-blog.csdnimg.cn/blog_migrate/97c985eda8927c60f1226d5fda425dc7.png) 

## 2-1 设置镜像

​        conda有时候安装软件会非常慢。设置国内镜像的话可以使安装更快捷一些。设置方法如下所示：

```shell
#设置清华镜像
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
#设置bioconda
conda config --add channels bioconda
conda config --add channels conda-forge
#设置搜索时显示通道地址
conda config --set show_channel_urls yes
```



## 2-2更新conda

- 将conda自身更新到最新版本，it is recommended to always keep conda updated to the latest version.         

```shell
conda update conda
```

## 2-3 更新Anaconda整体

- 将整个Anaconda都更新到确保稳定性和兼容性的最新版本

```shell
conda update Anaconda
```

## 2-4查询某个命令的帮助 

```shell
conda create --help
```



# 3- 管理环境

​    Conda允许你创建相互隔离的独立环境，这些环境被称之为虚拟环境

（Virtual Environment），这些环境各自包含属于自己的文件、包以及他们的依存关系，并且不会相互干扰。

        Anaconda有一个缺省的名为base的环境。但是不建议把程序放在base环境中，应该创建不同的虚拟环境分别管理不同的开发项目。这个涉及到一个根本的问题：为什么我们需要虚拟环境呢？举一个简单的例子，想象一下你有多个项目要开发，每个项目中都有一些包要依赖于某个共同的包，但是各自的所需要的版本不一致，有一些需要低版本的，有些需要高版本的。然后你就陷入了众口难调的困境。为不同的项目创建虚拟环境就可以把不同项目隔离开来，各自使用自己所需要的软件环境。

## 3.1 创建虚拟环境

- 使用conda创建虚拟环境的命令格式为:

```shell
conda create -n env_name python=3.8
```

- 这表示创建python版本为3.8、名字为env_name的虚拟环境。
-  创建后，env_name文件可以在Anaconda安装目录envs文件下找到。在不指定python版本时，自动创建基于最新python版本的虚拟环境.      



## 3.2 创建虚拟环境的同时安装必要的包

- 但是并不建议这样做，简化每一条命令的任务在绝大多数时候都是明智的（一个例外是需要反复执行的脚本）

```shell
conda create -n env_name numpy matplotlib python=3.8
```

## 3.3 查看有哪些虚拟环境

- 以下三条命令都可以。注意最后一个是”--”，而不是“-”.

```shell
conda env list
conda info -e
conda info --envs
```

- 所显示的列表中，前面带星号“*“的表示当前活动环境。比如说当前我的环境列表：

![img](https://i-blog.csdnimg.cn/blog_migrate/2e9b84cb928a22895fa02439c8ca659e.png) 

- 星号的位置表示我现在在base环境下工作。注意，也有不是显示base而显示root的，root是因为是以系统管理身份作业（？待确认）

## 3.4 激活虚拟环境

- 使用如下命令即可激活创建的虚拟环境。

```shell
conda activate env_name
```

- 此时使用python --version可以检查当前python版本是否为所想要的（即虚拟环境的python版本）。

        在4.6版本以前需要使用如下命令：
    
        Linux:  source activate your_env_name
    
        Windows: activate your_env_name
    
        但是为什么要停留在过去（4.6以前的版本）呢？毕竟现在至少已经有4.10版本了，所以如果你不是最新版本，运行一下"conda update conda"吧



## 3.5 退出虚拟环境

- 使用如下命令即可退出当前工作的虚拟环境。

```shell
conda activate
conda deactivate
```

- 有意思的是，以上两条命令只中任一条都会让你回到base environment，它们从不同的角度出发到达了同一个目的地。可以这样理解，activate的缺省值是base，deactivate的缺省值是当前环境，因此它们最终的结果都是回到base
- 这个只适用于4.6及以后版本。如果你还在4.6以前的话，参见上一条说明。

   

## 3.5 删除虚拟环境

- 执行以下命令可以将该指定虚拟环境及其中所安装的包都删除。

```shell
conda remove --name env_name --all
```

- 如果只删除虚拟环境中的某个或者某些包则是：

```shell
conda remove --name env_name  package_name
```

## 3.6 导出环境 

- 很多的软件依赖特定的环境，我们可以导出环境，这样方便自己在需要时恢复环境，也可以提供给别人用于创建完全相同的环境。

```shell
#获得环境中的所有配置
conda env export --name myenv > myenv.yml
#重新还原环境
conda env create -f  myenv.yml
```



# 4- 包（Package）的管理

## 4.1 查询包的安装情况

- 查询看当前环境中安装了哪些包

```shell
conda list
```

- 查询当前Anaconda repository中是否有你想要安装的包

```shell
conda search package_name
```

- 当然与互联网的连接是执行这个查询操作乃至后续安装的前提条件.

## 4.2 查询是否有安装某个包

- 用conda list后跟package名来查找某个指定的包是否已安装，而且支持*通配模糊查找。

    conda list pkgname        
    
    conda list pkgname*  

​      

如下所示：

![img](https://i-blog.csdnimg.cn/blog_migrate/f12c04a613ded77e1889dbd252b2d7c1.png) 

- 当然如果你确认是否有某个包的目的是要对其进行更新的话，那就直接执行conda update pkgname即可，如果该包没有安装的话，conda会报告PackageNotInstalledError错误（然后改用conda install即可），比如：

![img](https://i-blog.csdnimg.cn/blog_migrate/9ee678390c31d07a5314593413288b55.png) 

## 4.3 包的安装和更新

- 在当前（虚拟）环境中安装一个包：

```shell
conda install package_name
```

- 当然也可以如上所述在创建虚拟环境的同时安装包，但是并不建议。安装完一个包后可以执行conda list确认现在列表中是否已经包含了新安装的包。

- 也可以用以下命令安装某个特定版本的包(以下例为安装0.20.3版本的numpy)：

```shell
conda install numpy=0.20.3
```

- 可以用以下命令将某个包更新到它的最新版本 ：

```shell
conda update numpy
```

- 安装包的时候可以指定从哪个channel进行安装，比如说，以下命令表示不是从缺省通道，而是从conda_forge安装某个包。

```shell
conda install pkg_name -c conda_forge
```

## 4.4 conda卸载包

```shell
conda uninstall package_name
```

- 这样会将依赖于这个包的所有其它包也同时卸载。
- 如果不想删除依赖其当前要删除的包的其他包：

```shell
conda uninstall package_name --force
```

- 但是并不建议用这种方式卸载，因为这样会使得你的环境支离破碎，如以下（conda manual  description原文）所述：

![img](https://i-blog.csdnimg.cn/blog_migrate/f826d9fc385641d4393e9d57e6cca4a4.png) 

-  一个直观的理解就是，如果一个包A被删除了，而依赖于它的包B、C等却没有删除，但是那些包其实也已经不可用了。另一方面，之后你又安装了A的新版本，而不幸的是，B、C却与新版本的A不兼容因此依然是不可用的。



## 4.5 清理anaconda缓存

```shell
conda clean -p      # 删除没有用的包 --packages
conda clean -t      # 删除tar打包 --tarballs
conda clean -y -all # 删除所有的安装包及cache(索引缓存、锁定文件、未使用过的包和tar包)
```

- 关于清除命令的更详细的说明，可以执行以下命令进行查询：

>>conda clean -h

输出结果如下（一部分）： 

![img](https://i-blog.csdnimg.cn/blog_migrate/17fb23b144756184e73ef00683637054.png) 

- conda就像个守财奴一样，把每个历史安装包都会好好保存。。。好处是可以很方便地恢复到旧的历史版本，坏处是占内存空间。。。前两天由于安装一个新的包，系统报告“CondaMemoryError: The conda process ran out of memory. Increase system memory and/or try again.”，执行"conda -y -all"清除了约30G的空间！

# 5- Python版本的管理

## 5.1 将版本变更到指定版本

```shell
conda install python=3.9
python --version
```

- 更新完后可以用以下命令查看变更是否符合预期。



## 5.2 将python版本更新到最新版本

- 如果你想将python版本更新到最新版本，可以使用以下命令：

```shell
conda update python
```



# 6- conda install vs pip install 

## 6.1 有什么区别？

- conda可以管理非python包，pip只能管理python包。
- conda自己可以用来创建环境，pip不能，需要依赖virtualenv之类的。
- conda安装的包是编译好的二进制文件，安装包文件过程中会自动安装依赖包；pip安装的包是wheel或源码，装过程中不会去支持python语言之外的依赖项。
- conda安装的包会统一下载到一个目录文件中，当环境B需要下载的包，之前其他环境安装过，就只需要把之间下载的文件复制到环境B中，下载一次多次安装。pip是直接下载到对应环境中。
- conda只能在conda管理的环境中使用，例如比如conda所创建的虚环境中使用。pip可以在任何环境中使用，在conda创建的环境 中使用pip命令，需要先安装pip（conda install pip ），然后可以 环境A 中使用pip 。conda 安装的包，pip可以卸载，但不能卸载依赖包，pip安装的包，只能用pip卸载。

​     比如说，在某个环境中安装一个包，会出现以下打印信息： 

![img](https://i-blog.csdnimg.cn/blog_migrate/be9d22515eec97b121bee7ebec81b291.png) 



## 6.2 安装在哪里？

- conda install xxx：这种方式安装的库都会放在anaconda3/pkgs目录下，这样的好处就是，当在某个环境下已经下载好了某个库，再在另一个环境中还需要这个库时，就可以直接从pkgs目录下将该库复制至新环境而不用重复下载。

  

- pip install xxx：分两种情况，一种情况就是当前conda环境的python是conda安装的，和系统的不一样，那么xxx会被安装到anaconda3/envs/current_env/lib/python3.x/site-packages文件夹中，如果当前conda环境用的是系统的python，那么xxx会通常会被安装到~/.local/lib/python3.x/site-packages文件夹中 

- 

- 

  ## 6.4 如何判断conda中某个包是通过conda还是pip安装的？

- ​执行 conda list ，用pip安装的包显示的build项目为pypi。如下图所示：

![img](https://i-blog.csdnimg.cn/blog_migrate/0683ece3320fa827cfc98736e9f0fc4b.png) 

# 7- conda configuration

- conda的配置文件为".condarc"，该文件在安装时不是缺省存在的。但是当你第一次运行conda config命令时它就被自动创建了。".condarc"配置文件遵循简单的YAML语法。     



## 7.1 .condarc文件在哪儿？ 

- 执行conda info，会有信息显示如下所示：

![img](https://i-blog.csdnimg.cn/blog_migrate/a7df6041e9908acf3535b0e6f8da9232.png) 

## 7.2 Channel管理

- 追加conda-forge channel:

```shell
conda config --add channels conda-forge
```

- 移除conda-forge channel:

```shell
conda config --remove channels conda-forge
```

- 查询当前配置中包含哪些channels


```shell
conda config --get channels
```



