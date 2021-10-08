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
git push origin notebook

# publish 
# mkdocs gh-deploy --force
mkdocs notebook-pub --force