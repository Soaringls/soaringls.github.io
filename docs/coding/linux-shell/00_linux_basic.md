# Linux日常使用命令
## 基础使用
### 常用命令
#### 小工具
- `cmp [ARG] file1 file2` 
  >比较两个任意类型的文件，若内容相同则默认不输出任何信息，若内容不同则输出第一个不同<br>
  之处的字符和列数编号
- `diff [ARG] <文件|目录> <文件|目录>`逐行比较文件。如果指定目录则比较目录中相同文件名的文件，但不会比较其中子目录
- 日历
  `cal -3`查看最近3个月日历
  
#### 查看文件内容
```bash
#=============================================
#cat使用指南
#=============================================
cat [-n] test.txt      #test.txt的内容直接输出到终端，-n输出到终端的内容显示行号
#用file1中的内容覆盖掉file2的内容，
#param: -n表示将行号写入file2中
#param: -b表示将行号写入file2中，但空行没有行号
cat [-n][-b] file1 > file2 
```

#### 系统相关
```bash
nautilus .  #打开当前目录下文件管理器
cal -3     #查看当前月份的日历,当前为6月，将显示5-7月
echo "caros" | sudo -S shutdown now  #免密码关机,小写s也行 `echo "caros" | sudo -s shutdown now`
echo "12" | sudo -s chmod +x file    #免密码赋予执行权限
sudo apt-get install python-rosinstall -y #安装过程中默认选择Y
ln -s real_path_or_file soft_link_path_or_file  #创建软链接
```

- sleep
  ```bash
  sleep 1  #睡眠1s,同sleep 1s
  sleep 1m #睡眠1分钟
  sleep 1h #睡眠1小时
  ```

#### 开关机、移动复制、创建删除
```bash
sudo shutdown -r 0            #-r重启  0s后执行，sudo reboot
sudo shutdown -h 0            #同sudo shutdown -h now 立即关机
#===================
#复制移动cp/mv
cp src_file dest_file    #复制文件,src_file会覆盖dest_file
cp -i src_file dest_file    #复制文件,dest_file存在时会询问是否被src_file覆盖
cp -r /{path}/A /{path2}/B/   #把文件夹A复制到B中
cp -r  A/ B/ C   /home/tmp/ros/share    #从当前目录复制文件夹A、B、C到/home/tmp/ros/share
mv /{path}/A /{path2}/        #把文件夹A移动到路径path2下面,不需要-r参数
mv old new                    #将old目录移动并重命名为new
#将多个文件同时移动到指定目录 参数 -t
mv file1 file2 file3 -t  ../   #将当前目录下file1、file2、file3都移动至上层目录
cp file1 file2 file3 -t  ../   #将当前目录下file1、file2、file3都复制至上层目录
#===================
#删除rm
rm -rf velodyne               #删除文件夹velodyne及其中包含的文件夹和文件
rm *.pcd                      #删除当前目录下所有pcd格式点云文件
#===================
#mkdri创建目录
mkdir -p catkin/src           #创建目录catkin/src  不加-p参数只能创建单个文件夹catkin
touch old                     #新建old文件 

ctrl+h #是否显示隐藏文件
ctrl+l #显示目录
pwd    #显示当前完整的绝对目录

tail -200f /home/lyu/calib.txt #查看calib.txt中的后200行

du -sh work/*  #查看特定目录下各文件大小

#`df [ARG] [文件]`全称"DiskFree"显示系统可使用的磁盘空间
df -h  #查看不同盘符使用情况(包括挂载的盘符等)
```

#### 远程操作-需要安装ssh
[ssh操作](https://www.cnblogs.com/kex1n/p/6017963.html?utm_source=itdadao&utm_medium=referral) 
```bash
#ssh username@ip
ssh usery@192.168.10.6
```
#### scp操作

```bash
ifconfig #查看ip信息
#拷贝文件夹从pathA to pathB  
scp -r pathA  pathB  
scp ./*.bag   user@192.168.8.142:/home/user/cmake_velo/data/    
scp -r user@192.168.10.6:/home/user/apollo  /home/user/data/bag/
```


#### 权限相关
```bash
sudo -s     #获取root权限(exit/logout/ctrl+d退出)  sudo su也可切换到root用户，并可显示终端当前所在的完整目录

#取消0.2文件夹的root用户权限 取消root权限
sudo su->chown -hR orange:orange 0.2
sudo chown -hR orange 0.2 #同 sudo chown -hR orange:orange 0.2
sudo chown -R caros:caros apollo #修改apollo目录下所有文件权限为caros

#/etc/apt/sources.list下文件修改后怎么保存退出  
sudo gedit /etc/apt/source.list
```

>[chmod用数字来表示权限的方法](https://blog.csdn.net/my_wade/article/details/47066905)
```bash
#chmod abd file
#a:user b:group c:other  可读r=4 可写w=2 可执行x=1
#rwx 7  读、写、执行  
#rw- 6  读、写
#r-w 5  读、执行

#赋予velodyne及其子目录下文件”rwx“的权限
chmod 777 velodyne -R #-R 即对velodyne目录下的所有文件及其子目录进行相同的权限变更(即以递回的方式逐个变更）
```

#### 文件压缩、解压
```bash
tar -zcvf 压缩文件名.tar.gz 被压缩文件名 #压缩
tar -zxvf 压缩文件名.tar.gz            #解压-解压后文件只能放在当前目录
tar -zxvf 压缩文件名.tar.gz  -C <dir>  #解压-解压后文件位于指定目录

zip fileA   #压缩fileA
unzip fileB #解压fileB

unrar x fileA #解压
rar a fileA.rar fileA #压缩fileA
```


#### wget
```bash
#下载一个文件并保存在当前目录
wget http://cn.wordpress.org/wordpress-3.1-zh_CN.zip 
#使用wget -O下载并以"wordpress"的文件名保存 
wget -O wordpress.zip http://www.centos.bz/download.php?id=1080 
#使用wget -P $DIR $URL 下载到指定目录
#wget –limit -rate限速下载
wget –limit-rate=300k http://cn.wordpress.org/wordpress-3.1-zh_CN.zip 
```


#### 安装与卸载
```bash
sudo apt-get update
sudo apt-get upgrade
apt-cache search gflag*  #搜寻gflag相关的安装包或者库
sudo apt-get install glag* #安装

#干净卸载  sudo apt-get remove 或者 sudo apt-get autoremove卸载不干净  两个小时的教训！！！！！！！！！！！！！！！ 
#fuck the environment
sudo apt-get purge **** 
```

### 查看磁盘大小
```sh
du -sh ./*  #查看当前路径下各内容空间占用

```
### supervisor进程管理
安装supervisor`sudo apt-get install supervisor`
将每个进程的配置文件放在`/etc/supervisor/conf.d/`目录下，以`.conf`为拓展名
[ubuntu16_使用supervisor](https://www.cnblogs.com/xishuai/p/ubuntu-install-supervisor.html)

[进程管理supervisor说明](https://www.cnblogs.com/zhoujinyi/p/6073705.html)
[supervisor(1)基础篇](http://blog.51cto.com/lixcto/1539136)
 
### 增大虚拟内存
[增大虚拟内存](https://linuxize.com/post/create-a-linux-swap-file/)

```bash
sudo fallocate -l 16G /swapfile
sudo swapoff -a
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile  #sudo swapoff /swapfile 停用
sudo swapon --show
sudo free -h
```

### 监听端口
```bash
sudo lsof -i:8888
```

### tcpdump
```bash
sudo tcpdump -i eth0 -w file.p udp port 2014 #保存网口的数据到file.pcap,如保存北科天汇雷达数据
```

### nohup、进程
[nohup和&后台运行，进程查看及终止](https://www.cnblogs.com/baby123/p/6477429.html)

>后台启动后有事直接关掉终端后台进程也会自动关闭,可尝试使用exit退出终端避免该问题
```bash
#后台执行test.sh,默认log输出到当前目录下的nohup.out中,并显示当前进程的PID
nohup ./test.sh & 
#后台启动,并将log输出到当前目录下的nohup_test.out中
nohup ./test.sh>nohup_test.out 2>&1 & 
#查看后台进程,只能在当前终端生效！！！ 关闭终端后在另一个终端是能通过ps aux j| grep test.sh查询
jobs -l 
ps aux | grep test* | grep -v grep #查找进程并将grep自身排除
ps aux | grep test* | grep -v grep | awk '{print $2}' #使用awk提取进程的ID

#a:显示所有程序 u:以用户为主的格式显示 x:显示所有程序,不以终端机区分
ps auxf #ps即process status, ps auxf | grep vscode*,搜索vscode的进程
#显示进程名为program_name的ID, f参数匹配program_name
pgrep -f program_name
#显示进程名为program_name的进程的个数, f参数匹配program_name,c匹配数目
pgrep -f -c program_name

###**********************
###kill
###kill -Signal pid,默认15(SIGTERM),即kill -15 pid1 pid2 pid3,告诉进程1、2、3"你需要被关闭,请自行停止运行并退出"
###----------------------
kill pid1 pid2 pid3  
kill -9 pid1 pid2 pid3 #kill -9(SIGKILL)发送SIGKILL信号给进程”你被终结了,请立刻退出“
kill $(pgrep -f test.sh)            #杀死进程test.sh

printenv   #显示环境变量值  "printenv | grep ROS"显示ROS的环境变量值
```

### 三剑客 awk sed grep
- [ 性能工具之linux三剑客awk、grep、sed详解 ](https://mp.weixin.qq.com/s?__biz=MzIwNDY3MDg1OA==&mid=2247484984&idx=1&sn=9cbd41eaac5381f7250f1c1118685da6&chksm=973dd4dda04a5dcbf5b83939c48d94578a8937c1a5c61f3743f6d7b8b6b5efbff69db6816e74&mpshare=1&scene=1&srcid=0325QLcn4A1QOTybSkSxMZiP&pass_ticket=fQr7CNGwehzzUbllHOZD7ajpIkwvVYLB9O6YQislROek5x2FVewESx3J5BSa%2FIDn#rd)


- **sed** stream editor数据修改,编辑匹配到的文本
    >[sed命令用法](https://www.cnblogs.com/maxincai/p/5146338.html)
    >[linux中shell正则表达式](https://www.jb51.net/tools/shell_regex.html)
    ```bash
    sed -i s/address:.*/address:"asaf"/g test
    sed -i 's/address:.*/address:"asaf"/g' test
    ```

- [sed与正则表达(helpful)](https://mp.weixin.qq.com/s?__biz=MzI2NzE3NjQ2Ng==&mid=2650098312&idx=1&sn=8db88dd1de34704dd62599e178cb25d3&chksm=f28335f5c5f4bce309aebc2f34f4d28876d45608c63dd96f6280f8dcebc39cc3568a83b37877&mpshare=1&scene=1&srcid=0124C2T1nqN40XMnGMTN1AqP&pass_ticket=WKN0WrrA%2BngpcnKYE%2B1RIo2QHNmF4BAvgy%2FjHhgQBNdaKf41S3apnyK0jlq4GDoB#rd) 

>可以以非交互的方式编辑文件,对一个字符串进行`搜索和替换`为另一个字符串
```bash
#使用()组 \1,  必须使用 -r 参数
#参数i,编辑现有文件,而不仅仅是看改动后的效果
sed -i -r 's/([ |\t]*address).*/\1:"192.168.1.1"/' ../file/test
sed -i -r 's/([ |\t]*port).*/\1:2222/'  ../file/test

sed -i -r 's/^(workspace)[ ]*[0-9]+;$/\1 4;/' test #修改workspace的值

#查找文件test中包含”{/apollo/sensor/velodyne16/VelodyneScanUnified}“的内容,  [ ]与[]效果不一样
grep '[ ]*|[ ]*{[ ]*/apollo/sensor/velodyne16/VelodyneScanUnified[ ]*}' test
sed -i -r 's/([ ]*\|[ ]*\{[ ]*\/apollo\/sensor\/velodyne16\/VelodyneScanUnified[ ]*\})//g' test
sed -i -r 's/([ ]*\|[ ]*\([ ]*\/apollo\/sensor\/velodyne16\/VelodyneScanUnified[ ]*\))//g' test

```
**awk** 数据切片,格式化文本,对文本进行复杂格式化处理

## GDB调试
### GDB调试 Debug
(cpp)LINUX网络编程(第2版)-Page52
```bash
g++ -g example.cpp -o example1 #编译C++语言源文件
gcc -g example.c -o example    #编译C语言源文件
gdb example
gdb --args {biany} argv1 argv2 
gdb {binary} ${core_file}
#command in gdb
file <excutable_file> #加载可执行文件
set args <arguments>  #设置执行文件运行时需要的参数
core-file core    #加载当前core文件
info thread       #显示所有的线程
thread 1          #根据线程id查看某线程信息,如查看id为1的线程信息
bt                #当前线程的堆栈情况, `bt -20`则为查看最底层的20个调用
thread apply all bt #查看所有线程堆栈信息

l                 #即list, 显示程序行, 如`list ProE`即显示函数ProE的代码
r                 #即run, 开始运行
c                 #continue
q                 #退出
s                 #step,下一步，如果有函数会进入函数
n                 #next,下一步，如果有函数不会进入函数
p val             #打印值
```
### 多文件调试
```bash
b collator.cc:44  #collator.cc 44行处打断点，只有包含main函数一个文件时使用命令b num即可
delete 5          #删除5好断点
delete 1-10       #删除1-10号所有断点
clear             #删除所在行的所有断点
```
### core dump查找错误方法
```bash
ulimit -a           #查看,或者 ulimit -c查看,如果结果为0表示core dump是关闭的,不会生成core dump文件
ulimit -c unlimited #打开core dump,设置core文件大小不受限,或ulimit -c 500 即限制文件不超过500KB
ulimit -c 0         #关闭core dump
```


## linux的查找命令
[Linux的五个查找命令：find,locate,whereis,which,type 及其区别](https://www.cnblogs.com/kex1n/p/5233821.html)

### **find 可找到想找的任何文件**

- 查找文件：`find /path -name "filename"`
- 查找目录：`find /path -type d`
- 查找文件类型：`find /path -type f -name "*.txt"`
- 查找文件大小：`find /path -size +10M`
- 查找文件权限：`find /path -perm 777`


```bash
find . -name "my*"     #当前目录(含子目录,以下同)查找所有文件名以my开头的文件
find . -name "my*" -ls #当前目录(含子目录,以下同)查找所有文件名以my开头的文件,并显示详细信息
find . -type d #查看当前目录下所有目录(包括子目录包含的所有目录)
find . -type f #查看当前目录下所有文件(包括子目录包含的所有文件)

#----------------------------
# brief:与xargs结合使用
#----------------------------
find . -type f -size +1M ##查找当前目录所有大于`1M`的文件
find . -type d -size +1M ##查找当前目录所有大于`1M`的目录
find . -name "*x64*" | xargs rm -rf     #删除搜索的结果,find、rm组合使用
find . -name "*.so" -o -name ".a" -o -name ".git" | xargs rm -rf #删除当前目录下所有的 `.so` `.a`文件和 `.git`文件夹
find . -mtime +10 -name  "*" | xargs rm #删除搜索到的10天前的任何文件
find . -mmin  +10 -name  "*" | xargs rm #删除搜索到的10mins前的任何文件
find . -maxdepth 1  -group root -name bin #只查找当前目录下隶属root用户的名称为bin的文件
find . -group root -name bin              #只查找当前目录及其所有子目录下隶属root用户的名称为bin的文  件
find . -name "*.cpp" | xargs grep -n "main()" #在当前目录及子目录中所有cpp文件中搜索关键字main(),并  显示行号
```
### **locate** 快速定位文件

linux每天自动更新一次包含本地所有文件信息的数据库,locate不搜索具体目录而是搜索这个数据库,因此locate查不到最新变动过的文件,因此使用locate命令之前可以先使用updatedb手动更新数据库

```bash
updatedb
#搜索test中所有以fil开头的文件,即使当前目录为test,也不能用locate ./fil
locate  /home/lyu/Desktop/test/fil
locate  ~/Desktop/test/fil
```

### **whereis** 查找可执行文件路径

用于对程序名的搜索,
```bash
whereis grep #返回grep二进制文件的路径、man说明文件和参数文件的路经
```

### **which** 查找可执行文件路径

PATH变量指定的路径中,搜索某个系统命令的位置,可查看某个系统命令是否存在
```bash
which find #返回"/usr/bin/find"
```

### **type** 查看文件类型

查看某个命令的类型,如文件、目录、可执行文件、符号链接等
```bash
type ls #返回"ls is a shell builtin"
type cd #返回"cd is a shell builtin"
```

### **grep** 文本搜索命令

```bash
grep "boo" file1      #查询文件file1中包含"boo"的每一行
grep -n  "boo" file1  #查询文件file1中包含"boo"的每一行,带行号
grep -c  "boo" file1  #查询文件file1中包含"boo"共多少行,只显示匹配到的行的数量,小于等于"boo"的个数
grep -vn "boo" file1  #查询文件file1中不包含"boo"的每一行,带行号

n #显示行号
i #匹配字符串是忽略大小写
c #显示匹配到的行数

grep "e$" file1 #搜索file1中以e结尾的行,只有一行的最后一个字符为e才符合
grep -E "field1 | field2 | field3" target_file #匹配多个字段,from chh
``` 

## 重定向

### 常用命令 

`echo "hello" > /dev/null` ：将输出重定向到空设备文件，即不显示任何输出。

`echo "hello" > /dev/null 2>&1` ：将输出重定向到空设备文件，同时将错误输出重定向到标准输出。

```sh
/dev/null ：代表空设备文件
>  ：代表重定向到哪里，例如：echo "123" > /home/123.txt
1  ：表示stdout标准输出，系统默认值是1，所以">/dev/null"等同于"1>/dev/null"
2  ：表示stderr标准错误
&  ：表示等同于的意思，2>&1，表示2的输出重定向等同于1
```

`1 > /dev/null 2>&1` 语句含义：
`1 > /dev/null` : 首先表示标准输出重定向到空设备文件，也就是不输出任何信息到终端，说白了就是不显示任何信息。
`2>&1` ：接着，标准错误输出重定向（等同于）标准输出，因为之前标准输出已经重定向到了空设备文件，所以标准错误输出也重定向到空设备文件。

### 实例解析：

- cmd >a 2>a 和 cmd >a 2>&1 为什么不同？
```
cmd >a 2>a ：stdout和stderr都直接送往文件 a ，a文件会被打开两遍，由此导致stdout和stderr互相覆盖。
cmd >a 2>&1 ：stdout直接送往文件a ，stderr是继承了FD1的管道之后，再被送往文件a 。a文件只被打开一遍，就是FD1将其打开。
```
两者的不同点在于：
```
cmd >a 2>a 相当于使用了FD1、FD2两个互相竞争使用文件 a 的管道；
cmd >a 2>&1 只使用了一个管道FD1，但已经包括了stdout和stderr。
从IO效率上来讲，cmd >a 2>&1的效率更高。
```

## 挂载


重新挂载`/app`目录为读写模式：
```
mount -o remount,rw /app
```

 