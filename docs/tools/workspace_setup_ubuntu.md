# Setup worksapce in ubuntu
>environment: ubuntu18.04

## VPN
### v2ray(ref doc of yongcong)
### 
```sh
sudo apt install python3-pip
sudo pip3 install shadowsocks
#replace "EVP_CIPHER_CTX_cleanup" with "EVP_CIPHER_CTX_reset" of openssl.py by ":%s/old/new/g"
sudo vi /usr/local/lib/python3.8/dist-packages/shadowsocks/crypto/openssl.py
sslocal -c shadowsocks_vpn_jikess.json 
```
the content of shadowsocks_vpn_jikess.json is:
```
{
  "server":"tw-1.v2speed.net",
  "server_port":13871,
  "local_port":1080,
  "password":"4UlcsiptpO",
  "timeout":600,
  "method":"aes-256-cfb"
}
```
## vim
- vim默认显示行数设置
  `/etc/vim/vimrc`的最后一行加上`:set number`
## vscode
sync`setting.json` `extensions.json` `keybindingsMac.json`
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
  - [**自动跳转无效**](go to definition无效) 
    `C/C++插件设置 "C_Cpp.intelliSenseEngine": "Default"`,**之前`setting.json`误操作为Disabled, fuck!!!**
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