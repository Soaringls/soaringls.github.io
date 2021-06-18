#!/bin/bash

set -x
set -e  # exit if err

# vars
HEXO_DIR=$(cd $(dirname $0); pwd)/..
echo "dir: "$HEXO_DIR
# src filse
cd ${HEXO_DIR}
pwd
#git add .
#git add ./source/ ./script/ ./source_sample 
git add -u
git add docs script

commit_msg=$(date "+%Y.%m.%d %H:%M:%S")
git commit -m "update note $commit_msg"
git push origin new-note

# publish: hexo s启动本地服务
#hexo g -d
