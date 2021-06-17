# Setup worksapce in ubuntu
>environment: ubuntu18.04

## v2ray(ref doc of yongcong)

## vim
- vim默认显示行数设置
  `/etc/vim/vimrc`的最后一行加上`:set number`
## vscode
- 安装插件及Google代码风格保存自动格式化
```sh
#*************************
#@desc:c++ devel-env and autoformat by GoogleStyle
#*************************
#step1.install extensions:`C/C++、Clang-Format、`
#step2.install executable clang-format
sudo  apt-get install clang-format
#step3.config "clang-format"
Settings搜索"clang-format",配置"Clang-format:Fallback Style"为"Google即可"
"clang-format.fallbackStyle": "Google" #setting

#step3.config autoformat when save the file
#required: To automatically format a file on save, add the following to your vscode settings.json file
"editor.formatOnSave": true
#optional: 
"clang-format.executable": "/absolute/path/to/clang-format"
```
- 添加头文件路径
>按F1或 Ctrl+Shift+p 在弹出的备选选项中选择 C/C++:Edit Configuration(JSON)，自动打开c_cpp_properties.json

- FAQ
  - [**代码自动跳转失败**]"Visual Studio Code is unable to watch for file changes in this large workspace"
    **solution**
    `/etc/sysctl.conf`文件的最后一行加入`fs.inotify.max_user_watches=524288`vscode的文件监听数目,然后`sudo sysctl -p`重启即可

## git

```
sudo apt install git
# config
git config --global user.name "YongcongWang"
git config --global user.email "yongcong.wang@outlook.com"
git config --global core.editor vim
# generate key
ssh-keygen -t rsa -C "yongcong.wang@outlook.com"
```

### Config

1. Open [github](https://github.com/) and sign in;

2. In `Settings/SSH and GPG keys` click `New SSH Key`;

3. Paste `id_rsa.PUB`(in `/home/.ssh/id_rsa.pub`);

4. Test: `ssh -T git@github.com`.