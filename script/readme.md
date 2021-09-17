### mkdocs
```sh
#it's better install anaconda3
conda install -c conda-forge mkdocs
mkdocs serve #by terminator of system, not vscode

#to confirm
# pip3  install  mkdocs
# pip3 install mkdocs-cinder
```

### hexo faq
- usage
  ```sh
  set -e
  set -x
  hexo clean
  echo "clean over , and begin to generate the project, $1"
  if [ $1 == 'd' ]; then
    hexo g -d
  else
    hexo s -g
  fi
  ```
- faq: console.js:35 throw new TypeError('Console expects a writable stream instance');`
    **Solution**:可能有hexo-cli和nodejs版本有关，两种方法解决
    ```sh
    #solution1: 将hexo-cli的版本降级到： 3.1.0
    sudo npm install hexo-cli@3.1.0 -g
    #soluton2: 将node的版本升级到：10.13.0及以上 TODO
    ``` 
- faq:`hexo server`启动服务时候报错`FATAL Something's wrong. Maybe you can find the solution here: https://hexo.io/docs/troubleshooting.html
Error: watch /home/lyu/dexter/test/blog_ls/source/ ENOSPC`
   **Solution**
   ```sh
   #ref: https://hexo.io/docs/troubleshooting.html
   #solution1:
   npm dedupe
   #solution2:increase the limit for the number of files you can watch by using the command
   echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
   ```