### blog的hexo常见faq
- `
console.js:35
    throw new TypeError('Console expects a writable stream instance');`
    **Solution**:可能有hexo-cli和nodejs版本有关，两种方法解决
    ```sh
    #solution1: 将hexo-cli的版本降级到： 3.1.0
    sudo npm install hexo-cli@3.1.0 -g
    #soluton2: 将node的版本升级到：10.13.0及以上 TODO
    ``` 
- `hexo server`启动服务时候报错`FATAL Something's wrong. Maybe you can find the solution here: https://hexo.io/docs/troubleshooting.html
Error: watch /home/lyu/dexter/test/blog_ls/source/ ENOSPC`
   **Solution**
   ```sh
   #ref: https://hexo.io/docs/troubleshooting.html
   #solution1:
   npm dedupe
   #solution2:increase the limit for the number of files you can watch by using the command
   echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
   ```

   