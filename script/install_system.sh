#/usr/bin/bash

# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #脚本所在目录
DIR="$( cd $(dirname $0) && pwd)" #脚本所在目录
# DIR=$(dirname $(readlink -f "$0")) #执行目录，而非脚本所在目录

PKG_DIR=$DIR/../../../bak_work/package
echo "PKG_DIR"
if [ ! -e $PKG_DIR ];then
  mkdir $PKG_DIR
fi

# echo "install 坚果云....."
# wget https://www.jianguoyun.com/static/exe/installer/nutstore_linux_dist_x64.tar.gz -O $DIR/package/nutstore_bin.tar.gz
# mkdir -p $DIR/package/nutstore/dist 
# tar zxf $DIR/package/nutstore_bin.tar.gz -C $DIR/package/nutstore/dist
# $DIR/package/nutstore/dist/bin/install_core.sh #install

echo "install cuda...."
wget -P $DIR/package/ https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda_11.0.3_450.51.06_linux.run 
# sudo sh $DIR/package/cuda_11.0.3_450.51.06_linux.run