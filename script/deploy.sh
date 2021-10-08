#!/bin/bash
# set -x
set -e

DIR=$(cd $(dirname $0);pwd)/..
echo "DIR:${DIR}"

pwd

git add -u
git add script docs 

DATE=$(date "+%Y.%m.%d %H:%M:%S")
MSG="update note ${DATE}"
echo "commit msg:${MSG}"
git commit -m"$MSG"

# git push origin new-note
# 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
git push origin lyu/mkdocs-note

# publish 
# mkdocs gh-deploy --force
mkdocs lyu/mkdocs-note --force