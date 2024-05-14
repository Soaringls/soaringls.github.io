# ROS&Cartographer

## cartographer
###  install and build

[Cartographer ROS build and install](https://google-cartographer-ros.readthedocs.io/en/latest/)

```bash
# Install wstool and rosdep.
sudo apt-get update
sudo apt-get install -y python-wstool python-rosdep ninja-build

# Create a new workspace in 'catkin_ws'.
mkdir catkin_ws
cd catkin_ws
wstool init src

# Merge the cartographer_ros.rosinstall file and fetch code for dependencies.
wstool merge -t src https://raw.githubusercontent.com/googlecartographer/cartographer_ros/master/cartographer_ros.rosinstall
wstool update -t src

# Install proto3.
src/cartographer/scripts/install_proto3.sh

# Install deb dependencies.
# The command 'sudo rosdep init' will print an error if you have already
# executed it since installing ROS. This error can be ignored.
sudo rosdep init
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y

# Build and install.
catkin_make_isolated --install --use-ninja
catkin_make_isolated --install --use-ninja [-DCMAKE_BUILD_TYPE=Debug | Release | RelWithDebInfo | MinSizeRel]
source install_isolated/setup.bash
roslaunch cartographer_ros demo_backpack_3d.launch bag_filename:=/home/lyu//work/catkin_ws/data/changshu/2018-07-25-07-40-46.bag 

依赖的gflags和glog共享库位于/usr/lib/x86_64-linux-gnu/
```
### cartographer launch参数配置
1. backpack_3d.launch 映射topic remap
2. urdf传感器坐标文件配置
3. **backpack_3d.lua**
   ```bash
   num_point_clouds = 1
   num_accumulated_range_data = 1
   #default true old version hasn't this parameter
   use_pose_extrapolator = false  
   num_point_clouds = 1           #default 2
   num_accumulated_range_data = 1 #default 160
   ```
### cartographer总结笔记
1. **生成pbstream地图文件，并转为ros标准的格式的地图**
   -  使用offline_backpack_3d.launch
   - demo_backpack_3d.launch,构图过程中使用服务`rosservice call /write_state ${path}/file.bag.pbstream`

```bash
 #使用roslaunch
 roslaunch cartographer_ros offline_pbstream_to_rosmap.launch  pbstream_filename:=/home/cabin/Desktop/carto_map.pbstream  map_filestem:=/home/cabin/Desktop/ros_map resolution:=0.05
 #rosrun node
 rosrun cartographer_ros cartographer_pbstream_to_ros_map  -map_filestem=/home/cabin/Desktop/ros_map  -pbstream_filename=/home/cabin/Desktop/carto_map.pbstream -resolution=0.05
```

2. **rviz保存地图**

```bash
#安装map-server
sudo apt install ros-melodic-map-server
rosrun map_server map_server -f mymap
```

### 特点
- 主要通过闭环检测消除构图过程中产生的累计误差
- carto重点内容就是融合多传感器数据的局部submap创建，及闭环检测的scan match策略的实现
  - submap: 一个submap由一定数量的laser scan构成，新的laser scan进来时会基于submap已有的laser scan和其他传感器估计其在submap中的最佳位置，一个submap构建完成后不会有新的laser scan插入到该submap中，此刻submap会加入到闭环检测中
  - 闭环检测： 闭环检测考虑所有已完成创建的submap，新的laser scan与地图中某个submap中的某个laser scan的位姿接近的话就通过某种scan match策略找到该闭环
- 代码
  - carto负责处理来自雷达、IMU、里程计的数据并基于这些数据进行地图的构建--底层实现
  - carto_ros负责基于ros的通信机制获取传感器的数据并转换为carto中定义的格式传递给carto，同时将carto的处理结果发布，用于显示或保存--上层应用

- 位姿估计：先用相关性扫描匹配（CSM）给一个初值，然后构造一个最小二乘问题（与Hector超不多），求解精确的位置
  - CSM：简单来说大概是：用激光末端点匹配取到占据栅格地图中的值，获得得分，取得分最高的作为初值。加上多分辨率计算可以加速，并且获得分辨率意义下的最优解
  - 用分支定界原理加速求解过程（相对于暴力求解），进行深度有限优先搜索，CSM计算得到初始最高分数，确定深度，分支就是进行拓展，定界就是剪枝。提高运算效率
### tips
- LocalTrajectoryBuilder3D: extrapolator只能通过AddImu初始化，因此3D的时候必须使用IMU数据


## ros常用命令
 
1. **use_sim_time**
**命令设置**

    ```bash
    #true,bag数据回放时系统使用仿真时间，false时系统使用walltime，即系统当前时间
    rosparam set use_sim_time true
    ```
**roslaunch中设置**
    ```html
     <param name="use_sim_time" value="false" />
    ```
**坐标系统(frame)**
>ROS rviz中X(red)前、Y(green)、左Z上, apollo中Y前，X右

2. 基本命令

```bash
#build ros package
catkin_make -DCMAKE_BUILD_TYPE=Release 
catkin_make install -DCMAKE_INSTALL_PREFIX=/opt/ros/groovy 
catkin_make -DCATKIN_WHITELIST_PACKAGES="chapter2_tutorials" //编译单个功能包

#colcon: compile all modules
colcon build --cmake-args -DCMAKE_BUILD_TYPE=Debug Release
#colcon: compile special module
colcon build --packages-select ekf_localizer
rviz -d ./data/ces_mapping.rviz #open rviz by ces_mapping.rviz

rospack find roscpp
source /opt/ros/kinetic/setup.bash   //source ROS安装目录
rospack profile //更新ROS内部软件包，即功能包，类似sudo apt-get update更新Linux软件包一样

#将外部名为/levle1/topic1的topic映射到内部名为input的topic
rosrun object_tracking  main input:=/kitti/velo/pointcloud

#循环播放 -l ,加速2倍 -r 2 
rosbag play [-l] [-r 2] test.bag  

#记录topic生成bag包
rosbag record -a #记录所有topics
rosbag record -O bagname.bag /topicA /topicB  #bagname.bag
rosbag info bagname.bag                      #查看bag文件内容
rostopic echo /imu/data                  #输出topic的内容

#寻找可用的ros包
apt-cache search ros-kinetic-opencv*  
#卸载/opt/ros/kinetic目录下cartographer功能包
#distro为发行的版本,如indigo/kinetic/melodic 
sudo apt install ros-<distro>-ros-tutorials 

sudo apt purge ros-kinetic-cartographer 
sudo apt-get install ros-kinetic-rqt-console ros-kinetic-rqt-graph\
                     ros-indigo-pcl-conversions ros-indigo-pcl-ros
```


## gdb debug
```
<node pkg="lidar_localizer" type="lidar_mapping" name="lidar_mapping" output="screen" launch-prefix="xterm -e gdb -ex run --args" >
    <!-- time_config -->
    <param name="gps_lidar_time_threshold" value="$(arg gps_lidar_time_threshold)" />
    <!-- filter_params -->
</node>
```

## 消息回放数据
[sensor_msgs/PointCloud2 Message](https://blog.csdn.net/tiancailx/article/details/79076728)
```
deutsches_museum.bag---------------------------------------------------------------
start:        May 26 2015 21:30:16.48 (1432647016.48)
end:          May 26 2015 22:02:09.46 (1432648929.46)
size:         470.5 MB
messages:     617965
compression:  bz2 [3334/3334 chunks; 18.31%]
uncompressed:   2.5 GB @   1.3 MB/s
compressed:   462.3 MB @ 247.5 KB/s (18.31%)
types:        sensor_msgs/Imu                [6a62c6daae103f4ff57a132d6f95cec2]
              sensor_msgs/MultiEchoLaserScan [6fefb0c6da89d7c8abe4b339f5c2f8fb]
topics:       horizontal_laser_2d    70358 msgs    : sensor_msgs/MultiEchoLaserScan
              imu                   478244 msgs    : sensor_msgs/Imu               
              vertical_laser_2d      69363 msgs    : sensor_msgs/MultiEchoLaserScan
常熟数据----------------------------------------------------------------------------
duration:    4:12s (252s)
start:       Jul 17 2018 22:02:08.52 (1531836128.52)
end:         Jul 17 2018 22:06:21.10 (1531836381.10)
size:        4.0 GB
messages:    95162
compression: none [2320/2320 chunks]
types:       geometry_msgs/TwistWithCovarianceStamped [8927a1a12fb2607ceea095b2dc440a96]
             nav_msgs/Odometry                        [cd5e73d190d741a2f92e81eda573aca7]
             sensor_msgs/Imu                          [6a62c6daae103f4ff57a132d6f95cec2]
             sensor_msgs/NavSatFix                    [2d3a8cd499b9b4a0249fb98fd05cfa48]
             sensor_msgs/PointCloud2                  [1158d486dd51d683ce2f1be655c3c181]
topics:      /gps/fix           23209 msgs    : sensor_msgs/NavSatFix                   
             /gps/odom          23215 msgs    : nav_msgs/Odometry                       
             /gps/vel           23209 msgs    : geometry_msgs/TwistWithCovarianceStamped
             /imu/data          23209 msgs    : sensor_msgs/Imu                         
             /velodyne_points    2320 msgs    : sensor_msgs/PointCloud2
```
### rostopic echo /gps/fix
```
header: 
  seq: 20465
  stamp: 
    secs: 1531836210
    nsecs: 510304607
  frame_id: "gps"
status: 
  status: 1
  service: 1
latitude: 31.5925101489
longitude: 120.777609767
altitude: 12.1732759476
position_covariance: [0.08702499999999999, 0.0, 0.0, 0.0, 0.098596, 0.0, 0.0, 0.0, 0.505521]
position_covariance_type: 2
```
### rostopic echo /gps/odom
```
header: 
  seq: 23294
  stamp: 
    secs: 1531836238
    nsecs: 802880267
  frame_id: "utm"
child_frame_id: "base_link"
pose: 
  pose: 
    position: 
      x: 480.502068639
      y: -13.6451568799
      z: 0.0175981521606
    orientation: 
      x: 0.0
      y: 0.0
      z: 0.000639999956309
      w: 0.9999997952
  covariance: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
twist: 
  twist: 
    linear: 
      x: 0.0011
      y: 0.0008
      z: 0.0007
    angular: 
      x: 0.0
      y: 0.0
      z: 0.0
  covariance: [0.000361, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.00016900000000000004, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.00044100000000000004, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
```
### rostopic echo /gps/vel
```
header: 
  seq: 32407
  stamp: 
    secs: 1531836329
    nsecs: 939887881
  frame_id: "utm"
twist: 
  twist: 
    linear: 
      x: -4.8506
      y: -2.8112
      z: 0.0315
    angular: 
      x: 0.0
      y: 0.0
      z: 0.0
  covariance: [0.00019600000000000002, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.00032400000000000007, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.00044100000000000004, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
```
### rostopic echo /imu/data
```
header: 
  seq: 18441
  stamp: 
    secs: 1531836190
    nsecs: 268546124
  frame_id: "gps"
orientation: 
  x: 0.0131102252045
  y: -0.00598663135602
  z: -0.948375507513
  w: 0.316821998905
orientation_covariance: [4.0960000000000007e-07, 0.0, 0.0, 0.0, 3.364e-07, 0.0, 0.0, 0.0, 2.4649000000000007e-06]
angular_velocity: 
  x: -0.00608
  y: 0.00299
  z: -0.00579
angular_velocity_covariance: [0.000436332313, 0.0, 0.0, 0.0, 0.000436332313, 0.0, 0.0, 0.0, 0.000436332313]
linear_acceleration: 
  x: 0.1486
  y: -0.1413
  z: 9.6373
linear_acceleration_covariance: [0.0004, 0.0, 0.0, 0.0, 0.0004, 0.0, 0.0, 0.0, 0.0004]
```
### rostopic echo /velodyne_points
[点云数据格式解析 sensor_msgs::PointCloud2](https://blog.csdn.net/Fourier_Legend/article/details/83656798)
```
header: 
  seq: 0
  stamp: 
    secs: 1543222266
    nsecs: 674018000
  frame_id: "velodyne"
height: 1
width: 5190
fields: 
  - 
    name: "x"
    offset: 0
    datatype: 7
    count: 1
  - 
    name: "y"
    offset: 4
    datatype: 7
    count: 1
  - 
    name: "z"
    offset: 8
    datatype: 7
    count: 1
is_bigendian: False
point_step: 16  //一个点占用内存的字节数(byte). 4个uint32_t类型  uint_32为4bytes  32bits比特
row_step: 83040 //height=1时一行或者所有点占用内存的字节数，5190(点的个数)*4(xyzi uint32_t)*4(byte)
data: [201.....63]
is_dense: False
---
``` 