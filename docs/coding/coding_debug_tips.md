# Coding Debug Tips

## c++ 工程管理 

### 编码规范
- 返回类型及返回变量不要出错
- 类方法的签名和实现一致
- 头文件内实现函数容易出现重定义的问题,因此需将全局的函数声明和函数实现分开
- 类成员函数
  ```cpp
  const uint32_t frames_size() const { return frames_.size(); }  //ok
  const uint32_t& frames_size() const { return frames_.size(); } //error,怎么能返回临时变量的引用呢!!! 只能返回存在的成员变量的引用
  ```
- 类成员变量
  - 引用变量作为成员时必须初始化,没有初始化将造成构造失败

### 模块开发
1. 自定义赖库(common/data_parser/front_end...--> lidar_mapping)编译并安装到指定目录opt(依赖的gears里三方库找不到时候需设置环境比变量`export LD_LIBRARY_PATH=<...>`)
2. 自定义main程序(lidar_mapping --> map_creator, map_creator在cmake配置中只依赖lidar_mapping即可,不需写common|data_parser|front_end),**map_creator依赖common的某接口且该接口在lidar_mapping中未被使用时则map_creator也须依赖common**
   执行时找不到步骤1中的自定义赖库时,若找不到需设置opt的环境比变量`export LD_LIBRARY_PATH=<...>`)

### notice: 一个编译时问题的debug

- 编译时报错`./build/src/lidar_map_creator: error while loading shared libraries: libdata_parser.so: cannot open shared object file: No such file or directory`
- `libdata_parser.so`被安装到`opt/lib/map_pipline`里面,因此需要设置一下环境变量`export LD_LIBRARY_PATH=<...>`
- !!!注意
  **map_creator.sh中问题写法**
  ```sh
  #setp1:
  source $ABSOLUTE_DIR/../../../opt/setup.bash
  #setp2:
  MAP_LIBS="$ABSOLUTE_DIR/../../../opt/lib/map_pipline"
  echo "MAP_LIB:$MAP_LIBS"
  export LD_LIBRARY_PATH=$MAP_LIBS #貌似会覆盖第一步的设置,导致错误error while loading shared libraries: libyaml-cpp.so.0.6: cannot open shared object file: No such file or directory
  ```
  **map_creator.sh中正确写法**
  ```sh
  #setp1:
  MAP_LIBS="$ABSOLUTE_DIR/../../../opt/lib/map_pipline"
  echo "MAP_LIB:$MAP_LIBS"
  export LD_LIBRARY_PATH=$MAP_LIBS
  #setp2: 最好将MAP_LIBS也添加到opt/setup.bash的'export LD_LIBRARY_PATH'路径中
  source $ABSOLUTE_DIR/../../../opt/setup.bash
  ```

### notice: 一个运行时问题的debug

> **某shared.so: undefined symbol:某interface**: 即没有在依赖库**某shared**.so中找到接口**某interface**

- 命令`c++filt <interface>`查看实际命名的接口名称
- 命令`nm <shared>.so | grep <interface>`查看依赖库<shared>.so中是否有该接口

#### case
**运行时报错`libfront_end.so: undefined symbol: _ZN7autobot7mapping10DataCenter5init_E`**
  
1. 查看实际命名的接口名称
  
  `c++filt  _ZN7autobot7mapping10DataCenter5init_E`-->`autobot::mapping::DataCenter::init_`

>查看cmake配置发现`init_`明明已经编译到依赖的库`common`里面,然后`ldd`查看库的依赖关系(只能查看动态so库的依赖,不能是静态库),`nm`查看库中是否存在某接口

- `ldd <path>/libfront_end.so: `-->`libcommon.so =>/opt/lib/libcommon.so`,然而实际需要依赖`/opt/lib/map_pipline/libcommon.so`
- 命令`nm`在库`/opt/lib/libcommon.so`和`/opt/lib/map_pipline/libcommon.so`中查找接口`_ZN7autobot7mapping10DataCenter5init_E`,可发现在该接口只在后一个存在，`/opt/lib/libcommon.so`为早期无用的库,删掉后即可,**libfront_end.so会自动依赖正确的/opt/lib/map_pipline/libcommon.so**

### notice: gdb代码
- 代码运行core dump`terminate called after throwing an instance of 'YAML::BadFile'`
- debug编译依赖库,然后`gdb --args ./lidar_map_creator --flagfile=/home/lyu/conf/lidar_mapping_local.conf`
- 依赖库打断点`b lidar_utility.cc:73`
  >备注:打断点不带文件`b 10`，则默认为当前main函数的文件

## c++ 代码
### 单例使用中构造函数问题

```cpp
/**
 * @brief 单例模式宏定义内有默认构造
 */
#define DECLARE_SINGLETON_HMI(classname)                               \
 public:                                                               \
  static const std::shared_ptr<classname> &Instance() {                \
    static auto instance = std::shared_ptr<classname>(new classname());\
    return instance;                                                   \
  }                                                                    \
                                                                       \
 private:                                                              \
  classname(); /*声明默认构造函数*/                                       \
  DISALLOW_COPY_AND_ASSIGN(classname)
/**
 * @brief HDMap头文件中不可再申明默认构造，直接在cc文件实现默认构造即可
 */
class HDMap {
 public:
//   HDMap() = default;  //此处的默认构造会和宏定义中的申明冲突
  ~HDMap() = default;

  const std::string& get_version();
  Point2D local_point_;
  DECLARE_SINGLETON_HMI(HDMap);
};
```
### opencv
`cvtColor CV_BGR2GRAY未声明的标识符` 头文件引入 `#include <opencv2/imgproc/types_c.h>` 即可
   
### 栈溢出
**[堆栈问题]诡异问题 Stack smashing detected**


问题描述：
普通数组、std::array定义的数组在初始化时如果分配的空间比较大(位于栈区)，很容易存在Stack smashing的问题
如std::array<std::array<Cell 200>, 800> polar_data{};大概率存在栈区溢出引起程序诡异的偶发中断，而且无明显线索
解决方法：
避免在栈区分配较大的空间，最好使用`new`操作符在堆空间申请内存(如vector、map等)

### 头文件引用的位置和顺序


e.g.1 lidar_segmentation中引用lidar_common中的hpp文件时的顺序问题(使用clang-format的坑)引发的危机

e.g.2 pose_preparation中data_loader.h中引入头文件后，pose_preparation.h又引入data_loader.h引起`multiple definition of `， 通过将相关的头文件从data_loader.h移到pose_preparation.h得以解决

### pcl调用问题
![](./c++/img/debug_tips_pcl_nodelet_system_gears.png)
```
问题描述：
cyberverse/apps/catkin_ws下新加segment的nodelet包，调用cyberverse/src/lidar_segment库
lidar_segment库依赖gears里面的pcl，不管ros-segment包依赖系统pcl还是gears里的pcl都不正常

原因：
1. gears里面pcl和系统的pcl存在版本不一致问题,所以会启动失败
2. ros-segment里面用到的pcl_ros指定依赖系统的pcl,所以ros-segment只能依赖系统pcl
```
### 指针未初始化就直接使用
```
Assertion 'px != 0' failed. means that you're using a boost::shared_ptr before it's initialized somewhere.
```
### c++函数返回类型不能使用别名
```cpp
typedef pcl::PointXYZI PointT;
typedef pcl::PointCloud<PointT> PointCloud;
//头文件声明处，函数返回类型可使用别名
PointCloud::Ptr NormalFiltering(const PointCloud::Ptr& cloud);
//cc文件，函数返回类型不可以使用别名
PointCloud::Ptr NormalFiltering(const PointCloud::Ptr& cloud) {......} //PointCloud不识别
pcl::PointCloud<pcl::PointXYZI>::Ptr ClusterFilter::NormalFiltering() {....} //写具体才行
```
### 不能使用系统函数名做变量名称
```cpp
#include <stdlib.h>
//int rand = rand()%100 + 1;将报错`‘rand’ cannot be used as a function`
int index = rand()%100 + 1; 
```
### 未声明的变量传入
```cpp
//使用1-正确使用，内部初始化--调用的函数内部初始化指针，然后传入的`指针的引用变量`引用`函数内初始化好的指针`
PointCloudRgbPtr cloud_abovergb
//void AddColorForCloud(const PointCloudConstPtr cloud, PointCloudRgbPtr& cloud_rgb);
AddColorForCloud(const PointCloudConstPtr cloud, PointCloudRgbPtr& cloud_abovergb);

//使用2-正确使用，外部初始化--调用的函数内部直接引用外部初始化好的指针变量
PointCloudRgbPtr cloud_abovergb(new PointCloudRgb);
//void AddColorForCloud(const PointCloudConstPtr cloud, PointCloudRgbPtr& cloud_rgb);
AddColorForCloud(const PointCloudConstPtr cloud, PointCloudRgbPtr& cloud_abovergb);

//使用3-错误使用，内部初始化--只传入指针，cloud_abovergb将始终未初始化
PointCloudRgbPtr cloud_abovergb;
//void AddColorForCloud(const PointCloudConstPtr cloud, PointCloudRgbPtr cloud_rgb);
AddColorForCloud(const PointCloudConstPtr cloud, PointCloudRgbPtr cloud_abovergb);
```