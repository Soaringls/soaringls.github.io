# Python开发环境搭建

## 1. 下载安装python

下载安装python3.x版本，推荐下载安装Anaconda，Anaconda是一个开源的Python发行版本，包含了conda、pip、jinja2、numpy、scipy、matplotlib、pandas等常用数据科学库。

Anaconda安装包下载地址：https://www.anaconda.com/products/individual

## 2. 配置环境变量

配置环境变量，使得系统能够识别到python，并设置默认python版本。

```sh
# 查看系统中默认使用的python版本, python2或python3
python --version

# 查看系统中已安装的pip版本
pip --version
pip3 --version

# 配置环境变量
# 1.  `.bashrc`文件末尾添加以下内容
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/anaconda3/bin:$PATH"
 
# 4. 刷新环境变量
source ~/.bashrc

# 5. 查看环境变量
echo $PATH 

# 6.2.2 永久设置
# 打开`.bashrc`文件 
alias python='/usr/local/anaconda3/bin/python3.x'
 
# 刷新环境变量
source ~/.bashrc 
```

## 3. 安装常用库
### 常规方法
```sh 
# 1. 升级pip
pip install --upgrade pip

# 2. 安装numpy、scipy、matplotlib
pip install numpy scipy matplotlib pandas # or `pip3 install ....`

# 3. 安装jupyter notebook etc.
pip install jupyter opencv-python tensorflow \
            torch torchvision \
            moviepy \
            gtsam
# ######### for python3
pip3 --version
pyhton3 --version
## func1
pip3 install --user --upgrade pip
pip3 install setuptools
 
pip3 install numpy scipy matplotlib

##func2 本质同func1 
python3 -m pip install numpy scipy matplotlib
```

### 推荐方法(通过brew、conda)

- brew安装

```sh
brew tap homebrew/science && brew install numpy scipy matplotlib
```

- conda安装(丝滑) [conda download for mac-os](https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html)

```sh 
#conda !!! very good 解决了mac-m1安装scipy的问题
#1. download conda
#2. install
bash Miniconda3-latest-MacOSX-arm64.sh
#3. install pkg
export PATH="/Users/dexter/miniconda3/bin:$PATH"
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
#创建空间shuai_space并在空间内默认安装3.10版本的python
conda create -n shuai_space  python=3.10  
conda deactivate
conda env list

#激活默认使用空间shuai_space,可通过终端${USER}前名称判断是什么space
conda activate shuai_space  

#在当前默认space装pkg
conda install numpy pandas scipy matplotlib 

#在指定的space安装pkg
conda install -n shuai_space ipykernel --update-deps --force-reinstall 

pip3 install moviepy gtsam  #conda安装失败的可用pip 
``` 
<!-- 
---

## 第三方库的引入
```sh
#指定Python版本的依赖,安装gtsam的python版本
find_package( PythonInterp 3.6 REQUIRED )
find_package( PythonLibs 3.6 REQUIRED )
#指定环境变量,可写入'.bashrc'文件
export PYTHONPATH=/usr/local/cython
import gtsam
```

## 使用roslaunch启动是切记关闭roscore，重大事件！！！ fuck
roscore启动的情况加使用roslaunch里面的参数设置只有第一次有效，且永远只记得第一次的设值,坑爹！！！！
所以在修改launch文件里的参数后启动launch时，确保master已关闭

[Make sure that you have installed "catkin_pkg", it is up to date and on the PYTHONPATH](https://cloud.tencent.com/developer/ask/128041)
```bash
#/usr/lib/python2.7/dist-packages/catkin_pkg
locate catkin_pkg 
#/opt/ros/kinetic/lib/python2.7/dist-packages
echo $PYTHONPATH  
#将catkin_pkg dir附加到PYTHONPATH（用于此会话）,添加到 .bashrc中彻底解决
export PYTHONPATH=$PYTHONPATH:/usr/lib/python2.7/dist-packages
#/opt/ros/kinetic/lib/python2.7/dist-packages:/usr/lib/python2.7/dist-packages
source ~/.bashrc
echo $PYTHONPATH
``` -->
