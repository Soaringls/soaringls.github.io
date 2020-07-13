---
title: hexo usage when build myblog
date: 2020-07-04 18:10:03
categories: tools
tags:
 - tools
description: common command of hexo
---
### usage of hexo
#### common command of hexo
```sh
hexo c    #clean
hexo g -d #生成并上传
hexo s    #server
hexo s -g #生成并本地预览
```
#### commond reference of hexo
```sh
hexo new "postName" #新建文章
hexo new page "pageName" #新建页面
hexo generate #生成静态页面至public目录  hexo g
hexo server #开启预览访问端口（默认端口4000，'ctrl + c'关闭server） hexo s
hexo deploy #部署到GitHub hexo d
hexo help  # 查看帮助
hexo version  #查看Hexo的版本

hexo n == hexo new
hexo g == hexo generate
hexo s == hexo server
hexo d == hexo deploy
```

#### 文章加密
```sh
npm install --save hexo-blog-encrypt
```