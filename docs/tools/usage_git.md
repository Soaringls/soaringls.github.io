# Git常见命令使用

## 常用命令
### git日常使用
- git workflow
  - rebase 代替 merge的使用
  ```sh
  git rebase master #更新master后合并master到当前分支
  ```
  - normal workflow
    ```sh
    git add    #new file or modified file    之前的commit为 e.g commit0
    git commit #it's best to always keep 1 commit,e.g commit1
    git pull   #pull有会和本地merge产生一个新的commit,e.g commit2
    git rebase -i <id of commit0|head master> #合并commit1和commit2为一个新的commit2->1->3(text为commit1),超过HEAD一个身位
    git push [origin dev] #push content
    git pull [origin dev] #更新代码去除超前的commit,即commit2->1->3
    ```
  - advanced workflow
  **分支很久未更新时如何提交本地的大量改动**
    ```sh
    #branch lyu/tool很久未与master同步,远远落后master, 而且本地还存在多个commit,e.g commit1(早)->commit9(晚)
    
    #step.1 切到master 更新master
    git checkout master
    git pull origin master #git pull会更新origin下所有分支,但不能吧每个分支最新的内容拉下来(只能拉取本地不存在但远端存在的新的分支),需要通过'git pull origin   <branch-name>'单独更新某分支内容
    
    #step.2 切到目标分支lyu/tool,吧master上近期的变动同步过来
    git checkout lyu/tool
    git rebase master # 也可使用git merge master,但这样会把master近期所有变动的commit都带过来
    git status #本地此时有多commit,需要合并多个commit为一个
    
    #step.3 合并commit
    git rebase -i <commit_head_id> #即commit1的上一个commit_id, 内部切勿使用d误删某个commit, 使用squash将多个commit压缩为一个commit
    git push origin lyu/tool #分支lyu/tool合入master后gitlab会默认吧远程的该分支删掉,因此本地切勿基于该分支再次开发,否则下次提交时会……很麻烦,会产生上百个commit

    #step.4 新function的开发
    git pull origin master       #之前的lyu/tool合入master后更新master 
    git checkout -b <new-branch> #创建新的分支进行新任务的开发
    ```

- qcraft-maps-china
```sh
git status
git reset --hard
git lfs uninstall
git reset --hard
git lfs install
git lfs update
git branch
git pull origin dev --rebase
### work from youhuang 经过验证
git lfs uninstall
git reset --hard
git lfs install #git lfs update #lfs支持单独update
git pull origin dev --rebase
##.git/lfs/objects会保存某些组每次commit的大文件,可直接删除,仓库瞬间小很多
git lfs prune #从 lfs 中删除文件并推送到原点, 处理.git/lfs/object过大的问题, 
git remote prune origin
#临时方案,有待验证,不行就删掉
rm -rf chongqing
git status
git reset --hard
git pull origin dev --rebase
### work from chenyu(prt模型测试)  经过验证
#lfs pull不会更新全部文件，只会更新当前branch相关的文件(zoulu)
sudo apt-get install git-lfs
git lfs install
git lfs pull
```
- 安装git后初步配置
```bash
##全局配置
git config --global user.name    #查看当前用户
git config --global user.email   #查看当前绑定邮箱
git config --global user.name "Soaringls" #config

##repo目录下局部环境配置
git config --local user.name "Your Full Name" 
git config --local user.email "you@qcraft.ai" 
git config --local include.path "../.gitconfig"
#添加当前机器的ssh key到github(setting->SSH and GPS keys)
ssh-keygen -t rsa -b 4096 -C "<email_address>" #
cat ~/.ssh/id_rsa.pub #赋值key值到github
ssh -T git@github.com #验证
```
- 远程拉仓库自有-用户名**wo**<br>
```bash
git clone <url> #拉取代码,第一次输入用户名和密码
#拉取某分支到指定目录，拉完后可离线切换到任一分支
git clone [-b <branc_name>] <url> [<directory>]   #默认拉master到当前目录
git clone -b lidar-odom <url> ./ranger_lidar_odom #将ranger当前目录，仓库名为ranger_lidar_odom
###about submodules
#添加submodule
git submodule add <sub-repo url>
git clone <url> --recurse-submodule #拉取url地址仓库及子地url址仓库
#e.g git clone https://github.com/CPFL/Autoware.git --recurse-submodule #main and submodules repo together
git submodule update --init --recursive  #update submodules, such as dev-env|vehicles
git submodule foreach git pull origin master #更新每个submodules的master
git submodule update #更新新增的submodule代码
#删除submodule
git submodule deinit <sub-repo-name>
git rm <sub-repo-name>
#修改子模块url
#修改`.gitmodules`内url即可,然后`git submodule sync`
#保存第一次的username、password
git config credential.helper store
git config --global credential.helper store
```
- 如果仓库fork自他人**bai**,则需关联**bai**的仓库地址<br>
```bash
git remote add bai <bai_url> #其中"bai"为nickname,自定义
git fetch --all #查看origin和remote的fork信息(将显示origin和bai)
git fetch #更新所有branch
git fetch --tags #更新所有的tag
git remote -v   #查看origin和bai的fetch、push地址
```
- 添加本地改动或新增文件
```bash
git status #查看当前工程位置(master还是某分支)及文件状态
git diff <file> #查看文件的具体改动
git add -u                #add仓库原有文件的改动
git add <file|directory> #add新文件
git checkout --HEAD index.js #从远程仓库单独拉取index.js文件
```
- 提交本地修改和新增文件<br>
```bash
#nano:->ctr+x->y->enter)
git commit -m"<comment>"#新增提交，同时加comment
git commit               #新增提交，编辑器中加comment
git commit --amend       #修改上次的提交
```
- 拉取合并最新代码<br>
```bash
git pull bai master #拉取bai的最新代码
git pull origin master #拉取自己master的最新代码
```
- **git stash使用**
```bash
git stash save "save msg"
git stash list #查看有哪些临时的存储，stash@${0}是最近一次的stash保存
git stash show #现实改动，git stash stash@${3} 显示stash@${3}的变化
git stash apply stash@${$num} #使用某个存储 同时保留当前存储
git stash pop                #默认使用并删除最近一次的存储stash@${0}
git stash pop  stash@${$num} #使用并删除存储stash@${$num}
git stash drop stash@${$num} #丢弃stash@${$num}，即从列表里删除
git stash clear #清除所有存储
```
#### 常用指令
```bash
git rm --help         #查看rm帮助
git rm --cached index.js #取消追踪，保留本地文件
git rm --f index.js     #取消追踪并删除本地文件

git rm --cached -r my_directory #取消追踪目录及其子文件
git rm -r -f folderA    #删除folderA文件夹及里面所有文件

git reset <commit_id> --hard #回退都某一版的提交(当前改动将丢失)

```
#### 分支的使用
>新建本地分支/上传分支/删除远程分支<br>分支和主干的互相合并
```bash
git branch  #查看当前处于那个分支,若从未建过分支,则默认为remote/origin/master分支

#建立本地分支`branch_test`,同时切换到新建的remote/origin/branch_tes分支t
git checkout -b branch_test #新建并切换到新建分支
git checkout master      #切换到master分支(即remote/origin/master)
git checkout branch_test #切换到branch_test分支(即remote/origin/branch_test)

git branch    #可看到当前处于新建的branch_test分支
git branch -a #查看所有分支, 可看到 `remotes/origin/<brance_name>`,如branch_test
git branch -d branch_test #删除本地分支branch_test

#合并最新master内容到分支branch_test
git checkout master #切换到master
git pull bai master #拉取最新代码
git checkout branch_test #切换到分支
git merge master    #将origin/master内容更新到origin/branch_test

#合并分支branch_test内容到master
git checkout master    #切换到master
git pull origin master #更新代码
git merge branch_test  #将origin/branch_test内容更新到origin/master

git push origin master      #上传代码到master(可申请pull request合并到bai的master下面)
git push origin branch_test                    #上传代码,远程分支为`branch_test`
git push origin branch_test:branch_test_remote #上传代码,远程分支为`branch_test_remote`

#删除远程分支
git push origin :branch_test_remote            #上传空分支,即可删除名为`branch_test_remote`的远程分支
git push origin --delete branch_test_remote    #删除名为`branch_test_remote`的远程分支
##远程tag
git push origin tag -d tagName
##远端branch和tag重名时
git push origin :refs/heads/branchName    //删除远端branch
git push origin :refs/tags/tagName        //删除远端tag
git push --set-upstream origin lyu/notebook 
```
### tag
```sh
##list tag names
git tag -l  
## delete specific tag
git tag -d <tag-name> 
```

### url变化后repo的url更改f
```sh
#查看本地repo的url
git remote -v
#设置新的url, 然后git remote -v查看是否设置成功
git remote set-url origin git@gitlab-cn.qcraftai.com:qcraft-all/vehicles.git
```

### 撤销误操作的commit --amend
```sh
git reflog #查看git Head记录
bf81b971a1 (HEAD -> refactor/unique_ptr) HEAD@{0}: commit (amend): [posrt] ...
517bbf7d1a (origin/master, origin/HEAD, master) HEAD@{1}: checkout: moving from master to refactor/unique_ptr ##本来应该给予这个branch提交新的commit,结果amend
517bbf7d1a (origin/master, origin/HEAD, master) HEAD@{2}: pull origin master: Fast-forward
3fac916797 HEAD@{3}: checkout: moving from refactor/1209float-double to master

#修复git commit --amend误操作
git reflog #查看git Head记录
git reset --soft HEAD@{1} #回到刚刚创建分支的时候，--soft保留改动
git commit #创建新的commit
```
