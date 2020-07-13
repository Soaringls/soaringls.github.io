#!/bin/bash

set -x
set -e  # exit if err

# vars
HEXO_DIR=$(cd $(dirname $0); pwd)/..

# src filse
cd ${HEXO_DIR}
git add .
git commit -m "update note"
git push origin note

# publish
hexo g -d
