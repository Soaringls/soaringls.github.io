#### 遇到如下问题，可能有hexo-cli和nodejs版本有关，两种方法解决
```
console.js:35
    throw new TypeError('Console expects a writable stream instance');
```
1. 将hexo-cli的版本降级到： 3.1.0
   `sudo npm install hexo-cli@3.1.0 -g`
2. 或将node的版本升级到：10.13.0及以上
   `todo`