个人年度总结(2020年1月-至今)
### 1-2月
- openapi部分(包好server state openapi三大模块)
梳理microcar的openapi模块逻辑及解决线上bug，后交付于王甲
- patrol模块
调研车辆patrol模块功能及其在microcar系统、终端ipad、小程序之间的作用，搭建patrol模块代码架构(李平江协同)及demo测试，后交于周雨潮
### 3-4月(cybertron->cybert代码移植)
- driver
  - 移植gnss、lidar(velodyne、robosense、surestar)驱动及在cybert车上测试验证
  - 梳理各driger逻辑及上车方法并移交给李春里
- openapi
  - 在王甲完成基础部分的基础上，新编写openapi对hdmap依赖部分的代码(microcar的patrol和hdmap代码未开源)，并对openapi进行全模块编译联调后测试，后由王甲进行后续测试及维护和功能开发
### 5-9月(定位见图组开发)
- 建图点云数据预处理模块开发: 通过对点云进行分割聚类，结合hdmap滤除道路上的动态障碍物
- 辅助工具开发: record数据包channel提取工具、hdmap数据准备工具、绘图分析工具
- 点云配准: 调研点云配准方法,基于pointmatcher编写online定位激光里程计及其测试优化(完成80%)
### 9月(测试部)
上海及无锡测试部署支持
### 10月至今
- autoware雷达定位模块
  自助开发slam建图框架，已完成建图模块(100%)
- lio-sam(10%)