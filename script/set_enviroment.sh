 
#!/bin/bash
# By yongcong.wang @ 27/02/2020
set -x
set -e

# env
REPO_DIR="$(cd $(dirname $0); pwd)/.."
echo "Repo dir is ${REPO_DIR}"
cd ${REPO_DIR}

# nodejs
# curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y libssl1.0-dev nodejs-dev node-gyp
sudo apt-get install -y nodejs #10.13.0及以上

# hexo
sudo apt install npm
sudo npm install -g hexo-cli
sudo npm install

# sudo npm install hexo-cli@3.1.0 -g

# theme
THEME_NEXT_DIR=${REPO_DIR}/themes/next
git clone https://github.com/theme-next/hexo-theme-next ${REPO_DIR}/themes/next
mv ${THEME_NEXT_DIR}/_config.yml ${THEME_NEXT_DIR}/_config.yml.bk
ln -s ${REPO_DIR}/conf/_config_next.yml ${THEME_NEXT_DIR}/_config.yml
cp ${REPO_DIR}/source/images/website/* ${THEME_NEXT_DIR}/source/images/

# test
hexo clean
hexo g
hexo s