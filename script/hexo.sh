set -e
set -x
hexo clean
echo "clean over , and begin to generate the project, $1"
if [ $1 == 'd' ]; then
  hexo g -d
else
  hexo s -g
fi