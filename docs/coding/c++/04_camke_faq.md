# Cmake FAQ&Examples

## Cmake FAQ
### 基本使用
>**CMakeLists.txt中的命令不区分大小写，可全部大写或小写**

`ccmake build10_vtk       #查看修改编译配置`
- 编译命令设置
  >使用是`-D${COMMAND}=${VALUE}`如`camke -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR -DCMAKE_BUILD_TYPE=Debug ../`,将覆盖CMakeLists.txt内的相关配置信息

- 编译类型
命令设置`-DCMAKE_BUILD_TYPE=[Debug | Release | RelWithDebInfo | MinSizeRel]`
cmake文件内`set(CMAKE_BUILD_TYPE Release[Debug | RelWithDebInfo)`
- 其他cmake系统set的常规配置
```sh
#配置编译器
set(CMAKE_C_COMPILER /usr/bin/gcc CACHE PATH "")
set(CMAKE_CXX_COMPILER /usr/bin/g++ CACHE PATH "")

set(CMAKE_CXX_STANDARD 11[14]) #编译c++标准
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11 -pthread")
```
- 设置编译时终端编译内容颜色
对于gcc4.9以上编译器，在CMakeLists.txt中添加`add_compile_options(-fdiagnostics-color=auto)`，注意这样设置*set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}"  -fdiagnostics-color=auto)*是无效的

### 犯过的傻瓜问题
- 编译pcl找不到vtk, 单命令的在build目录下`cmake ..`可以找到，使用脚本找不到(还傻乎乎的从其他地方拷贝pcl或者安装vtk7.1，一顿乱搞)
  `cmake -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR -DWITH_VTK=TRUE -DCMAKE_BUILD_TYPE=RelWithDebInfo ../`，必须将脚本内`-DWITH_VTK`设为`TRUE`才行啊！
- **只改了代码可以只make,改过cmake则须清掉build重新cmake ..构建工程然后make**改过`CMakeLists.txt`后一定要将之前构建的cmake工程配置删除掉(即将build文件夹内容删除掉)，否则新的改动将有可能不会生效
  e.g:`/usr/include`和`/usr/local/incldue`下有不同版本的eigen,而pcl依赖前者的eigen时程序才能正常工作，如果pcl内build之前构建的工程配置依赖后者的话，改掉`CMakeLists.txt`使得依赖`/usr/include/eigen3`后必须删掉build中内容重新`cmake ..`

### 第三方库的另类引入方式
#### find_path和find_library的使用
```sh
#引入eigen3
find_path(EIGEN3_INCLUDE_DIR Eigen
	/usr/include/eigen3
)
include_directories(SYSTEM "${EIGEN3_INCLUDE_DIR}")
#引入libusb
find_path(LIBUSB_1_INCLUDE_DIR
      NAMES libusb-1.0/libusb.h
      PATHS /usr/include /usr/local/include /opt/local/include /sw/include
      PATH_SUFFIXES libusb-1.0)

find_library(LIBUSB_1_LIBRARY
      NAMES usb-1.0
      PATHS /usr/lib /usr/local/lib /opt/local/lib /sw/lib)
#引入yaml
find_path(yaml-cpp_INCLUDE_DIRS yaml-cpp/yaml.h
            /usr/local/include
    )
find_library(yaml-cpp_LIBRARIES yaml-cpp PATHS
            /usr/local/lib
    )
```

## Cmake of example 

chapter examples from slambook1

- from“一起做RGB-D SLAM(6)”-g2o
```bash
#将g2o引入自己的cmake工程
# 添加g2o的依赖
# 因为g2o不是常用库，要添加它的findg2o.cmake文件
LIST( APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake_modules )
SET( G2O_ROOT /usr/local/include/g2o )
FIND_PACKAGE( G2O )
# CSparse
FIND_PACKAGE( CSparse )
INCLUDE_DIRECTORIES( ${G2O_INCLUDE_DIR} ${CSPARSE_INCLUDE_DIR} )
#同时，在代码根目录下新建cmake_modules文件夹，把g2o代码目录下的cmake_modules里的东西都拷进来，保证cmake能够顺利找到g2o
```
 
### ch02
```bash
# 声明要求的 cmake 最低版本
cmake_minimum_required( VERSION 2.8 )

# 声明一个 cmake 工程
project( HelloSLAM )

# 设置编译模式
set( CMAKE_BUILD_TYPE "Debug" )

# 添加一个可执行程序
# 语法：add_executable( 程序名 源代码文件 ）
add_executable( helloSLAM helloSLAM.cpp )

# 添加一个库
add_library( hello libHelloSLAM.cpp )
# 共享库
add_library( hello_shared SHARED libHelloSLAM.cpp )

add_executable( useHello useHello.cpp )
# 将库文件链接到可执行程序上
target_link_libraries( useHello hello_shared )
```
### ch03
```bash
cmake_minimum_required( VERSION 2.8 )
project( useEigen )

set( CMAKE_BUILD_TYPE "Release" )
set( CMAKE_CXX_FLAGS "-O3" )
#set(CMAKE_CXX_FLAGS "-std=c++11")

# 添加Eigen头文件
include_directories( "/usr/include/eigen3" )

# in osx and brew install
# include_directories( /usr/local/Cellar/eigen/3.3.3/include/eigen3 )

add_executable( eigenMatrix eigenMatrix.cpp )
----------------------------------------------------------
cmake_minimum_required( VERSION 2.8 )
project( visualizeGeometry )

set(CMAKE_CXX_FLAGS "-std=c++11")

# 添加Eigen头文件
include_directories( "/usr/include/eigen3" )

# 添加Pangolin依赖
find_package( Pangolin )
include_directories( ${Pangolin_INCLUDE_DIRS} )

add_executable( visualizeGeometry visualizeGeometry.cpp )
target_link_libraries( visualizeGeometry ${Pangolin_LIBRARIES} )

```
### ch04
```bash
cmake_minimum_required( VERSION 2.8 )
project( useSophus )
set(CMAKE_BUILD_TYPE "Debug")
# 为使用 sophus，您需要使用find_package命令找到它
find_package( Sophus REQUIRED )
include_directories( ${Sophus_INCLUDE_DIRS} )

add_executable( useSophus useSophus.cpp )
target_link_libraries( useSophus ${Sophus_LIBRARIES} )

```
### ch05
```bash
cmake_minimum_required( VERSION 2.8 )
project( joinMap )

# 添加c++ 11标准支持
set( CMAKE_CXX_FLAGS "-std=c++11 -O3" ) #O3 not 03

# opencv 
find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS} )

# eigen 
include_directories( "/usr/include/eigen3/" )

# pcl 
find_package( PCL REQUIRED COMPONENT common io )
include_directories( ${PCL_INCLUDE_DIRS} )
add_definitions( ${PCL_DEFINITIONS} )

add_executable( joinMap joinMap.cpp )
target_link_libraries( joinMap ${OpenCV_LIBS} ${PCL_LIBRARIES} )

```