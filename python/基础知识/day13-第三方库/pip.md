# 1- 更新pip

```shell
python.exe -m pip install --upgrade pip
```

![1727599924464](assets/1727599924464.png)



# 2- 设置下载第三方库的源

``` shell
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple


pip config get global.index-url                                       
https://mirrors.aliyun.com/pypi/simple


```

![1727600181013](assets/1727600181013.png)



# 3- 安装第三方库

```shell
pip install xxxxxx
```

![1727600307018](assets/1727600307018.png)





# 4- 查看安装了哪些第三方库

```shell
pip list
```

![1727600352214](assets/1727600352214.png)

# 5- 卸载第三方库

```shell
pip uninstall xxxxx
```

![1727600458060](assets/1727600458060.png)







