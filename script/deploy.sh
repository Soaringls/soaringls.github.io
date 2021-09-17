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

git push origin new-note

# publish
mkdocs gh-deploy --force