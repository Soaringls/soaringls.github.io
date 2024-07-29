# Setup work space on Mac
## install tools
- install Xcode ｜ vscode
- install command line tools
- install homebrew
 
```sh
#install brew: ref https://blog.csdn.net/muyimo/article/details/125211460
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
#更新homebrew资源
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH #加到 ~/.zshrc
source ~/.zshrc

brew update
brew install clang-format #c++
brew install shfmt        #shell
brew install isort black flake8       #python
#查看clang-format路径 `/opt/homebrew/bin/clang-format`
which clang-format 
```
 
- install vim

## remote development
1. machine1和machine2 vscode install plugin `remote-ssh`
2. machine1和machine2生成新的SSH密钥对: `ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`, 生成的公钥通过`cat ~/.ssh/id_rsa.pub`查看
3. 配置server: machine1 remote server
   ```bash
   # copy content of machine1's public key(`~/.ssh/id_rsa.pub`) to remote server's `~/.ssh/authorized_keys`
   ```
4. 配置machine1
   ```bash
   ## /Users/{username}/.ssh/config 里加入如下内容
   Host {serverNickName} # 自定义主机名
    HostName 172.18.3.29 # 远程服务器IP地址
    User {username} # 远程服务器用户名
    ProxyCommand ssh -W %h:%p M1
    IdentityFile /Users/{machine1-username}/.ssh/id_rsa # 私钥文件路径
   ```
5. machine2通过machine1连接到server 
   ```bash
   #step1: copy content of machine2's public key(`~/.ssh/id_rsa.pub`) to machine1 and remote server's `~/.ssh/authorized_keys`
   #step2: modify /Users/{machine2-username}/.ssh/config, 加入如下内容
   Host {machine1-nickname}
       HostName <machine1-ip>
       User {machine1-username}
       IdentityFile /Users/{machine2-username}/.ssh/id_rsa 
   
   Host {server-nickname}
       HostName 172.18.3.29 # 远程服务器IP地址
       User {username} 
       ProxyCommand ssh -W %h:%p {machine1-nickname}
       IdentityFile /Users/{machine2-username}/.ssh/id_rsa
   ```
  
6. client免密登录serer
   ```bash
   #step1: generate public-key on client(machine1 or machine2)
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

   #step2: copy content of client's public key(`~/.ssh/id_rsa.pub`) to server's `~/.ssh/authorized_keys`
   you can use `ssh-copy-id` to copy public key to remote server
   ssh-copy-id -i ~/.ssh/id_rsa.pub {username}@{server-ip}

   #step3: copy the below content to of `~/.ssh/sshd_config` of server
   PubkeyAuthentication yes
   AuthorizedKeysFile .ssh/authorized_keys

   #step4: test and use client to connect server without password
   ```

## shortcuts
- common shortcut cmd

  | info                           | shortcut                 |
  | :----------------------------- | :----------------------- |
  | redo(vscode)                   | command + shirt + z      |
  | 新建terminal(当前活动体为终端) | command+n                |
  | 不同terminal之间切换           | command+`                |
  | terminal新增tab窗口            | command+t                |
  | terminal切换tab窗口            | command+shift+左右方向键 |
在Mac电脑上，快捷键可以极大提升操作效率。以下是一些常见的Mac键盘快捷键，按照不同的类别进行分类，并以Markdown格式提供：

```markdown
# Mac键盘快捷键

## 基本操作
- `Command + C`: 复制
- `Command + V`: 粘贴
- `Command + X`: 剪切
- `Command + Z`: 撤销
- `Command + Shift + Z`: 重做
- `Command + A`: 全选
- `Command + F`: 查找
- `Command + S`: 保存
- `Command + W`: 关闭窗口
- `Command + Q`: 退出应用程序

## 窗口管理
- `Command + M`: 最小化窗口
- `Command + Shift + M`: 将窗口还原到最小化前的状态
- `Command + H`: 隐藏窗口
- `Command + Option + M`: 将窗口移动到屏幕的左侧
- `Command + Option + H`: 将窗口移动到屏幕的右侧
- `Command + Option + F`: 进入全屏模式

## 应用程序切换
- `Command + Tab`: 切换应用程序
- `Command + ` (反引号键): 切换到同一应用程序的不同窗口

## 屏幕截图
- `Command + Shift + 3`: 截取整个屏幕
- `Command + Shift + 4`: 选择屏幕的一部分进行截图
- `Command + Shift + 4` 然后 `Space`: 截取窗口

## 系统功能
- `Command + Space`: 打开Spotlight搜索
- `Command + L`: 光标移动到地址栏（仅限浏览器）
- `Command + ,`: 打开系统偏好设置
- `Command + Option + Esc`: 打开强制退出窗口

## 系统快捷键
- `Control + Command + Q`: 锁定键盘和屏幕
- `Control + Command + Eject`: 将屏幕关闭（如果支持）
- `Control + Shift + Eject`: 休眠模式（如果支持）

## 特殊功能
- `Command + Option + P + R`: 重置NVRAM或PRAM
- `Command + Option + Shift + Delete`: 将文件移至废纸篓并清空废纸篓
```

这些快捷键可以适用于大多数Mac操作系统，但某些快捷键可能会根据应用程序的不同而有所变化。使用这些快捷键，可以更快地执行日常任务，提高工作效率。
 