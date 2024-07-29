# Setup for Ubuntu
[enviromentj of sys and devel](#系统环境及开发环境)
[tools and plugin](#使用工具及插件)

## DeveloperOps

### Bazel



## 系统环境及开发环境 

### 纯净ubuntu的基本预装
- 查看ubuntu版本信息
```sh
uname -a #"详细信息"
uname -s #"Linux" or "Darwin"
uname -m #"aarch64" or "x86_64"
lsb_release -a #ubuntu18 or 22 etc
cat /etc/lsb-release #查看ubuntu镜像的发行版本号
cat /etc/issue       #查看ubuntu版本
```
- 预装工具
```sh
## install sudo
apt-get update && \
      apt-get -y install sudo
###显示的告知密码以及'yes'
echo "passwd of user"| sudo -S apt-get -y install vim
#
sudo apt-get -y install vim git tree npm \
                pkg-config \
                python3 python3-dev python3-numpy python3-pip
```
- 创建新用户
```bash
###添加新用户
sudo adduser caros #创建用户 添加用户caros
sudo vim /etc/sudoers #使caros用户具有root权限,编辑sudoers,在'root ALL=(ALL) ALL'后添加一行'caros ALL=(ALL) ALL'
cat /etc/passwd #查看用户列表
sudo su         #切到root用户, sudo -s也行
su caros        #由root用户切到caros用户
sudo passwd caros #reset passed of user 'caros' 

userdel -r caros #root用户下,删除caros用户
sudo userdel -r caros #普通非caros用户下,删除caros用户
sudo chown -R caros:caros apollo #把apollo权限改为caros
```
- 新用户".bashrc"
```sh
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#source /opt/ros/melodic/setup.bash 
alias python=python3 
```
### ubuntu新用户语言问题
```sh
#安装支持中文,但系统需要为英文
sudo apt-get install locales language-pack-zh-hans
export LANG="zh_CN.UTF-8" #仅在当前终端支持中文且为中文环境
#echo 'export LANG="zh_CN.UTF-8"' >> ~/.bashrc #系统lang将为中文
echo 'export LANG="en_US.UTF-8"' >> ~/.bashrc #系统为英文

#明明安装了中文支持，在系统为英文的情况下竟然还不支持中文，在"/var/lib/locales/supported.d/zh-hans"内添加"zh_CN GB2312"，然后执行命令"sudo locale-gen"即可
cat /var/lib/locales/supported.d/zh-hans
zh_CN.UTF-8 UTF-8
zh_SG.UTF-8 UTF-8
zh_CN.GBK GBK
zh_CN GB2312
 cat /var/lib/locales/supported.d/en
en_HK.UTF-8 UTF-8
en_DK.UTF-8 UTF-8
en_IN UTF-8
en_IL UTF-8
en_ZM UTF-8
en_ZW.UTF-8 UTF-8
en_NZ.UTF-8 UTF-8
en_PH.UTF-8 UTF-8
en_NG UTF-8
en_US.UTF-8 UTF-8
```
### 预装工具
```bash
#vim/ssh/tree/terminator

#vim编辑器,vim-scripts是基本插件，如语法高亮，缩进等
sudo apt install vim  vim-scripts vim-doc  nerdtree ctags   
sudo apt install tree       #用于查看目录 ”tree catkin_ws"查看catkin_ws目录下tree; tree//查看执行tree命令当前目录
sudo apt install terminator #多窗口终端
```
### 系统时间及盘符不识别
```bash
#ubuntu(16.04)/windows系统时间不一致问题
sudo timedatectl set-local-rtc 1 #重启后硬件时间UTC改为CST
sudo apt-get install ntpdate     #ubuntu下更新时间
sudo ntpdate time.windows.com
sudo hwlock --localtime --systohc #将时间更新到新硬件

#解决ubuntu关机自动重启进默认win10的问题
sudo apt-get install laptop-mode-tools 

#修复无法访问windows下D盘问题
sudo ntfsfix /dev/sdb5 
```
### 依赖库安装(非源码安装)
```sh
#1.通过源码安装
#2.apt-cache search lib*** 后在线装库(库文件和头文件是分开的！！！！！！！！)
#如install vtk
sudo apt-get -y install libvtk7.1\   #库文件
                     libvtk7-dev  #头文件
```
- caros-microcar deplibs install
```sh
### caros's microcar 
sudo apt-get update
sudo apt-get -y install cmake libeigen3-dev zlib1g-dev libssl-dev \
                        python-dev libconsole-bridge-dev libbz2-dev \
                        liblz4-delibyaml-cpp-dev libgtest-dev \
                        libgoogle-glog-dev libpoco-dev libopencv-dev \
                        libproj-de libpcap-dev node libboost-all-dev python-yaml

# install PCL
sudo rm -f /etc/apt/sources.list.d/v-launchpad-jochen-sprickerhof-de-*
sudo apt-get purge libpcl-*
sudo add-apt-repository ppa:v-launchpad-jochen-sprickerhof-de/for-ros
sudo apt-get update
sudo apt-get -y install libpcl-*

# install VTK
sudo apt-get -y install tcl-vtk python-vtk libvtk-java

# cd <your work root>/baidu/adu/cybertron
bash runlidar.sh 1 
```
### google-chrome浏览器
```bash
ghelper下载:http://googlehelper.net/  （upc_ls@163.com Ghelper.1992）
#将下载源加入到系统的源列表
sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/ 
#导入谷歌软件的公钥，用于下面步骤中对下载软件进行验证。如果顺利的话，命令将返回“OK”
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -
#对当前系统的可用更新列表进行更新 
sudo apt-get update
#执行对谷歌 Chrome 浏览器（稳定版）的安装 
sudo apt-get install google-chrome-stable
#启动谷歌 Chrome 浏览器
/usr/bin/google-chrome-stable
```
### 视频相关
- peek
  ```sh
  sudo add-apt-repository ppa:peek-developers/stable
  sudo apt update
  sudo apt install peek
  ```
- 录屏kazam
  ```sh
  #dia制图工具
  sudo apt install dia 
  #录屏工具1
  sudo apt-get install kazam
  
  #录屏工具2
  https://github.com/phw/peek
  sudo add-apt-repository ppa:peek-developers/stable
  sudo apt update
  sudo apt install peek
  ```
- 视频转gif工具--ffmpeg
  ```bash
  sudo add-apt-repository ppa:kirillshkrogalev/ffmpeg-next 
  sudo apt-get update
  sudo apt-get install ffmpeg
  #验证安装是否完成
  ffmpeg -version
  
  #视频转gif
  #func1--使用默认参数，转后的gif一般比原视频还大
  ffmpeg -i test.mp4 out.gif 
  #func2---设置参数
  # ss 2 to 12 表示从从视频的第2秒开始, 长度为12秒
  # -s         表示用于设定分辨率
  # -r         用于设定帧数，通常Gif有15帧左右
  ffmpeg -ss 2 -t 12 -i test.mp4 -s 649x320 -r 15 output1.gif
  
  #加速:将原始视频4倍播放保存
  ffmpeg -i nn.mp4 -filter:v "setpts=0.25*PTS" nn.acc.mp4
  #慢速:将原始视频1/4倍播放保存
  ffmpeg -i nn.mp4 -filter:v "setpts=4*PTS" nn.slow.mp4
  ```
  
### VPS
- shadowsockes
  ```sh
  #################################
  #海外服务器短:vps机器-洛杉矶
  vultr_username:sxls1992@gmail.com
  vultr_passwd  :vultr.VPS2020
  ssh登录后passwd改密码
  vps_ip:149.248.38.201 pwd:lyu@1992
  #1. install shadowsocks
  apt-get install python-pip
  pip install git+https://github.com/shadowsocks/shadowsocks.git@master
  snap install shadowsocks #可选
  #2.1 start
  ssserver -p 443 -k password -m aes-256-cfb
  #2.2 start runing in the background
  sudo ssserver -p <port> -k <passwd> -m aes-256-cfb --user nobody -d start
  sudo ssserver -p 1080 -k lyu@1992 -m aes-256-cfb --user nobody -d start
  #3. stop the server
  sudo ssserver -d stop
  
  #################################
  #网页端或者移动端
  配置好vps的ip(45.77.125.30)、已启动的端口(1080)、加密方式(如aes-256-cfb)、vps机器密码
  ```
- v2ray
  ```sh
  dacong-移动端Shadowrocket节点配置: 类型 vmess
  1.地址 "vps.yongcong.wang"
  2.端口 "1234"
  3.UUID "a90597c1-bab3-4217-ad6f-0838675c8633"
  
  #me
  vps_ip:149.248.38.201 pwd:lyu@1992
  PORT:41584
  UUID:7113a4ae-4177-47ed-8267-708982fd9c51
  ```
### 网易云音乐安装(optional)
```bash
sudo dpkg -i netease-cloud-music.deb
#安装若发生错误需重新配置依赖 
sudo apt-get -f install #然后再次安装
#查看软件包是否存在 
dpkg -l | grep netease-cloud-music
#卸载 
sudo apt-get remove netease-cloud-music  
#启动云音乐 
sudo netease-cloud-music
#解决不能通过图标快捷方式启动云音乐的问题 
nano /usr/share/applications/netease-cloud-music.desktop
#然后Exec那行的%U前加上 --no-sandbox  ctrl+X保存 重启或注销重新登录即可
```
### 火狐浏览器安装(optional)
```bash
#下载
http://www.firefox.com.cn/download/
#如下命令解压或者右键提取文件解压
tar jcf Firefox-latest.tar.bz2
#备份系统预装的Firefox
sudo mv /usr/lib/firefox /usr/lib/firefox_ubuntu 
#用中国版替换
sudo mv firefox /usr/lib/firefox 
#系统预装的Firefox是通过脚本启动，而中国版没有，因此要将该脚本复制过来
#然后退出账号重启浏览器，切换到本地服务登录账号即可
sudo cp /usr/lib/firefox_ubuntu/firefox.sh /usr/lib/firefox/firefox.sh 

#使用安装使用lantern后浏览器会无法访问出现“the proxy server is refusing connections”的提示，在火狐的设置里面选择“Network Proxy”中的setting选择“No proxy”即可
```
## 使用工具及插件
### vscode-latex
[reference](https://zhuanlan.zhihu.com/p/65931654?utm_source=qq)
1. 环境deps
   ```bash
   sudo apt-get install texlive-latex-base
   sudo apt-get install latex-cjk-all
   sudo apt-get install texlive-latex-extra
   sudo apt-get install texmaker
   sudo apt-get install texlive-xetex
   sudo apt-get install texlive-publishers
   ```
2. vscode安装Latex Workshop
3. 设置->Settings->Estensions->Latex寻找`Edit in settings.json`打开settings.json加入
    ```
    "latex-workshop.latex.recipes": [
        {
            "name": "xelatex",
        "tools": [
          "xelatex"
        ]
        },
        {
        "name": "xelatex->bibtex->exlatex*2",
        "tools": [
          "xelatex",
          "bibtex",
          "xelatex",
          "xelatex"
        ]
      }],
     
    "latex-workshop.latex.tools":[
        {
            "name":"xelatex",
            "command": "xelatex",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "%DOC%"
            ]
        }, {
            "name":"bibtex",
            "command": "bibtex",
            "args": [
                "%DOCFILE%"
            ]
        }
    ],
    ```
4. 重启vscode后打开`.tex`文件，点击左侧`TEX`模块,build->view即可
### qt安装
```bash
#下载地址：https://download.qt.io/archive/qt/5.5/5.5.1/
chmod u+x file.run //赋予权限   使用chmod命令使文件可由任何用户执行和运行chmod a+x cfg/chapter2.cfg
sudo ./file.run   //执行安装
#安装后启动qt报错“Cannot load library /opt/Qt5.5.1/Tools/QtCreator/lib/qtcreator/plugins/libHelp.so: (libgstapp-0.10.so.0: cannot open shared object file: No such file or directory)”
#执行下面3条安装语句即可：
sudo apt-get install libqt4-dev
sudo apt-get install libgstreamer0.10-dev
sudo apt-get install libgstreamer-plugins-base0.10-dev

#qt中导入整个工作空间
#由于catkin_ws/src工作空间里的CMakeLists.txt是链接文件，所以不能直接导入到Qt，执行以下命令
cd  catkin_ws/src
sed -i  CMakeLists.txt
```
### TeamViewer
```bash
sudo apt-get install -f
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i asdfasfs
```
### wps
```bash
#下载linux版本： http://www.wps.cn/product/wpslinux/
#安装
sudo dpkg -i wps-office.deb
#下载缺失字体：https://pan.baidu.com/s/1eS6xIzo 
#将解压后的wps_symbol_fonts  移动至/usr/share/fonts
sudo mv wps_symbol_fonts /usr/share/fonts
sudo mkfontscale和sudo mkfontdir  #生成字体索引信息
sudo fc-cache                     #更新字体缓存
```
### wps桌面便签小工具
```bash
sudo add-apt-repository ppa:umang/indicator-stickynotes
sudo apt-get update
sudo apt-get install indicator-stickynotes
```
### xmind安装
[Ubuntu16.04LTS安装 XMIND8 Pro](https://blog.csdn.net/qq_35976351/article/details/79329958)
```bash
#ubuntu14的话先安装openJDK8
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get udpate
sudo apt-get install openjdk-8-jdk
```