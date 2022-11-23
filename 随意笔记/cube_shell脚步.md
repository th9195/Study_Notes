



## Trunk

svn: svn://fhbbssvn2.fiberhome.com:3702/project/2019405_AIR1201-D01/trunk



shell 脚步 AIR1201-D01_IOT:

FH_AIBS_ORITGZ=(
/opt/MT8167S-AIR1201-D01/MTK8167s_origin_20190424.tar.gz
)









## Branch



svn: svn://fhbbssvn2.fiberhome.com:3702/project/2019405_AIR1201-D01/branches/brn_duotel_dev



shell 脚步 AIR1201-D01_IOT:

FH_AIBS_ORITGZ=(
/media/new/MTK8167s_origin_20190424.tar.gz
)





## 抓日志



adb logcat -vtime>C:\Users\Turtle\Desktop\micbasex\log.txt







## 拉SVN 上的代码



​	SmartBuild中的 ./AI_Build_mtk.sh aiv8167sm3_bsp AIR1201-D01_IOT AIR1201-D01_IOT 1 0 eng  第四个参数把1 改为0，可不删除源码目录，只更新服务器上代码。以加快编译速度。

​	附件的AI_Build_mtk_optimize.sh 同理，并增加了如下三个控制位。可根据自己需要开关。里面配置了所有路径下的权限。

``` python
###调试用快速编译控制项begin####
QUICK_BUILD_UPDATE="true"  ###为false时，不会从svn服务器更新代码###
COMPLE_NDK="false"   ###为false时，不会编译zigbee部分###
COMPLE_ZIP="false"  ##true代表编译update.zip升级包##

```



## 拷贝日志脚步   pulllog.bat

``` python

adb root
adb remount

@echo off
set d=%date:~0,4%-%date:~5,2%-%date:~8,2%
set hour=%time:~,2%
set min_sec=%time:~3,2%-%time:~6,2%
if "%time:~,1%"==" " set hour=0%time:~1,1%
set t=%hour%-%min_sec%

@echo on
set FOLDER=%d%_%t%

mkdir %FOLDER%

adb pull /cache/recovery/ %FOLDER%/
adb pull /data/anr/ %FOLDER%/
adb pull /data/tombstones/ %FOLDER%/
adb pull /sdcard/mtklog/ %FOLDER%/
::adb logcat -G 20m
::adb logcat > %FOLDER%/logcat.log

@echo off
set /p DEL_LOG="Delete /sdcard/mtklog/  log? (y/n .Default is n)"

if not defined DEL_LOG set DEL_LOG=n

if %DEL_LOG% neq y GOTO SKIP_DEL_MTKLOG
if %DEL_LOG%==y GOTO DEL_MTKLOG

:DEL_MTKLOG
    echo "start delete /sdcard/mtklog/"
    adb shell rm -rf /sdcard/mtklog/*

:SKIP_DEL_MTKLOG
    

echo "THIS"
pause

```





##  查看内存free -h

​	

aiv8167sm3_bsp:/ # free -h 
free -h
                		total        used       		free      shared     buffers
Mem:             978M        938M        	 40M        1.6M         21M
-/+ buffers/cache:          917M             61M
Swap:            733M         28M        	   706M



##  查看app 占用内存大小dumpsys meminfo


aiv8167sm3_bsp:/ # dumpsys meminfo
dumpsys meminfo
Applications Memory Usage (in Kilobytes):
Uptime: 74470789 Realtime: 74470789

Total PSS by process:
     75,571K: com.fiberhome.duotel (pid 1349 / activities)
     62,623K: com.android.systemui (pid 819)
     59,258K: com.azero.sampleapp (pid 1288)
     55,310K: system (pid 663)
     32,491K: com.android.settings (pid 965)
     28,604K: com.fiberhome.bluetoothplayer (pid 1557)
     25,194K: zygote (pid 508)
     24,864K: surfaceflinger (pid 261)
     15,296K: com.android.bluetooth (pid 1162)
     10,548K: android.process.media (pid 1225)
      9,828K: camerahalserver (pid 528)
      9,646K: com.fiberhome.iothub (pid 1863)
      8,847K: android.hardware.audio@2.0-service-mediatek (pid 246)



## 手动启动某个apk

1. **azero apk**
   - adb shell am start com.azero.sampleapp/.activity.launcher.LauncherActivity
2. **原生界面**
   - adb shell am start com.android.settings/com.android.settings.Settings

​		



## azero 平台账号

		13126895527  Duotel@123   多彩账号
		https://azero.soundai.com/iot/
		
		Azero IoT开放平台


​		
​		https://doc-iot-azero.soundai.cn/
​		
​		声智账号： 15327329617	wang0317   账号
https://azero.soundai.com/   官网


https://azero.soundai.com/ask/home


15327329617	wang0317   账号

多彩账号
		13126895527  Duotel@123   

		duotelCube
		5ee6c0f998bee7000ab273fd
		57a811313f05709f9e1cb66f2ff4052f

https://github.com/sai-azero/Azero_SDK_for_Android  github

下面的是我们技能相关的示例和文档
skill 文档: https://github.com/sai-azero/azero-skills-readme
python 文档: https://github.com/sai-azero/azero-skills-kit-sdk-for-python
nodejs 文档: https://github.com/sai-azero/azero-skills-kit-sdk-for-nodejs
nodejs 示例: https://github.com/sai-azero/azero-skills-kit-sdk-for-nodejs
java 示例: https://github.com/sai-azero/skill-sample-java-hello-world





## cube 版本获取

  FTP服务器：10.96.163.11 

  端口号：24 
  账号和密码：public/public 
  路径 ：/JenkinsTemp/SmartHome/AIR1201-D01/AIR1201-D01_IOT-IOT-MTO-AI04-FH-V4.0-202010300932-V100R003.01





## MAC  连接171 或150 服务器



ssh tanghui@10.96.163.171

密码：tanghui



ssh htang103_60026@10.96.163.150     

密码：htang103_60026





## RJ11测试环境搭建



admin 

admin

网络》语音配置》基本参数

ifconfig br0 192.168.1.10

ifconfig veip0.0 1.2.3.4

sip server 192.168.1.108





# Duotel



## duotel 开发文档账号：

fiberhome@duotel.cn

123456



## duotel 配置账号：

wangshihan@duotel.cn

duotel@123