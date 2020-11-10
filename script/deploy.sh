#!/bin/bash

set -x
set -e  # exit if err

# vars
HEXO_DIR=$(cd $(dirname $0); pwd)/..
echo "dir: "$HEXO_DIR
# src filse
cd ${HEXO_DIR}
git add .
commit_msg=$(date "+%Y.%m.%d %H:%M:%S")
git commit -m "update note $commit_msg"
git push origin note

# publish
hexo g -d
