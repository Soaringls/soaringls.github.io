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
 