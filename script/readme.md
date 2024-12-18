### mkdocs
```sh
#it's better install anaconda3
conda install -c conda-forge mkdocs
conda install mkdocs-material pymdown-extensions --force
mkdocs serve #by terminator of system, not vscode

#to confirm
# pip3  install  mkdocs
# pip3 install mkdocs-cinder
```

### mkdocs theme
```
name: material
 #material: just like cong
 #mkdocs: just like libpointmatcher
 #readthedocs: just like google etc opensource style
```
### 常见问题
- 部署失败：`mkdocs gh-deploy --force`报错`fatal: the remote end hung up unexpectedly`
  - 增加Git缓冲区大小：这个错误通常是因为推送的数据超过了Git服务器的配置限制，尤其是当仓库包含大文件或者一次性推送大量更改时。你可以通过增加Git缓冲区大小来解决这个问题。对于HTTP，可以运行以下命令：`git config --global http.postBuffer 524288000`,对于ssh,可以运行`git config --global ssh.postBuffer 524288000`

  - 更新MkDocs：有时候，这个问题可能是由于MkDocs版本过旧导致的。尝试更新到最新版本的MkDocs：
    ```sh
    pip install -U mkdocs
    pip install -U mkdocs==1.5.3
    ```