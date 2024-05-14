# Setup work space on Mac
## install tools
- install Xcode ｜ vscode
- install command line tools
- install homebrew
 
```sh
#install brew: ref https://blog.csdn.net/muyimo/article/details/125211460
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
#更新homebrew资源
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
 