---
title: icp算法的20年
date: 2020-07-08 11:07:05
mathjax: true
categories:
  - paper
  - algorithm
tags: 
  - pointcloud
  - registration
---
$$
y = \frac{a}{b}
$$
### ETH-libpointmatcher使用
使用的eigen版本需和pcl的一致，

科学实验方法的三个原则: 可比较(可评估)、可复现(稳定重复)、可证明(可解释)
算法内在：什么参数、不同参数下表现的差异
算法外在：准确度、精度
<!-- more -->
The first one is to remove some points that do not bring any valuable infor-
mation for the registration. As the complexity of the algorithm is linear
in the number of points, reducing this number can have a significant
impact on the time of registration. The second use of filters can be to
add information to the point. The typical example is the inference of
local structural properties of the shape, such as normal information or
curvature. This information, which is usually not present in the raw
sensor data, can allow for better registration through a more precise
association of the points, or the computation of the error to minimize

$$
\hat{T^B_A}=arg\min_{T}(error(T(P^A),Q^B))
$$

different platform 

| parameters | Arto(rough Terrain outdoor robot) |
| :--------- | :-------------------------------- |
| DataFilter |                                   |

### ICP of ETH

#### Dependency
1. eigen:matrix and liear-albebra library
2. libnabo:from eth, a fast k nearest neighbour library for low-dimensional spaces
3. libboost

#### Data flow of ETH-ICP <br>

  ![](/images/lidar-odometry/libpointmatcher/default_icp_chain.svg)
  ![](/images/lidar-odometry/libpointmatcher/icp_tutorial_reading.gif)

#### Theory of eth-icp algorithm
![](/images/lidar-odometry/eth-icp-basic-algorithm.png)
1. Reading and Reference Sources
shapes P are point clouds and can be written in a matrix form with each column a point vector:
$$
\mathcal P = \bold P=[p_1\quad p_2\quad ...\quad p_N]
$$
where $p_i$is a point and N the number of points in the point cloud
Features is an [Eigen matrix](http://eigen.tuxfamily.org/dox/classEigen_1_1Matrix.html) typically containing the coordinates of the points which form the cloud.  Each column corresponds to a point in the cloud.  The rows correspond to the dimensions of the points in homogeneous coordinates.  Homogeneous coordinates are used to allow for translations and rotations.  For 2D point clouds, there will thus be 3 rows and for 4 rows for 3D point clouds.

![features matrix](/images/lidar-odometry/libpointmatcher/featuresMatrix.png) 
<!-- <img src="/images/lidar-odometry/libpointmatcher/featuresMatrix.png" style="float:center" /> -->

1. Transformation Functions
   In case of a rigid transformation, if points are represented using homogeneous coordinates, a transformation T can be represented as a matrix T such that:
   
   $$
   \mathcal T(\mathcal P) = \boldsymbol{TP} = [\boldsymbol{T}\boldsymbol{p_1}\quad \boldsymbol{T}\boldsymbol{p_2}\quad ...\quad \boldsymbol{T}\boldsymbol{p_N}]
   $$

   $\boldsymbol{T}$ is  then of the form:
   
   $$
   \boldsymbol{T} = \begin{bmatrix}\boldsymbol{R} & \boldsymbol{t} \\ \boldsymbol{0^T} & 1       
   \end{bmatrix} 
   $$

   where$\boldsymbol{R}$ is a rotation matrix and $\boldsymbol{t}$ is a translation vector

   The generic formula computiing the final transform Equation becomes a simple matrix product:

   $$
   \begin{aligned}
   \hat{\mathcal{T}}_{\mathbb{A}}^{\mathbb{B}} = ({\mathop{\bigcirc}\limits_{ \mathcal{T}_{i-1}^i)\circ\mathcal{T_{init}} \\ \Leftrightarrow \hat{\boldsymbol{T {\mathbb{A}}^{\mathbb{B}}=\left(\mathop{\prod}\limits_{i}\boldsymbol{T}_{i ^i\right)\boldsymbol{T}_{init}
   \end{aligned}
   $$

   $$
   \hat{T^B_A}=arg\min_{T}(error(T(P^A),Q^B))
   $$
   ![](/images/lidar-odometry/eth-icp-flow-graph.png)

2. Data Filters
   - Feature Enhancement
   - Descriptor Enhancement
   - Feature Reduction
     features are sparse but not uniformly distributed. Nevertheless, the fact that sensors can provide a huge number of readings on a short period of time reates a bottleneck in term of computation power for the association as explained later
   - Sensor Noise
     example1:
     random subsampling in order to decimate the point cloud:
     
     $$
     \mathcal{P}^{\acute{}} = datafilter(\mathcal{P}) = \{\boldsymbol{p}\in\mathcal{P}:\eta(\boldsymbol{p}) < \theta\}
     $$
     
     where $\eta\in[0,1)$ is a uniform-distributed random value and θ ∈ [0, 1] a fixed threshold, corresponding to the fraction of points to keep
     
     example2:
     the computation of normal vectors in a point cloud:
     
     $$
     \mathcal{P}^{\acute{}} = datafilter(\mathcal{P}) = \{\boldsymbol{p}\in\mathcal{P}:\eta(\boldsymbol{p}) < \theta\}
     $$

    datafilter example:
    ![descriptors matrix](/images/lidar-odometry/libpointmatcher/descriptorsMatrix.png)
    **Surface Normal Filter**
    The surface normal to each point is estimated by finding a number of neighboring points and taking the eigen-vector corresponding to the smallest eigen-value of all neighboring points.
    __Required descriptors:__ none   
    __Output descriptor:__   
    `normals`  
    `densities`  
    `eigValues`  
    `eigVectors`  
    ![](/images/lidar-odometry/libpointmatcher/orient_norm.png)
    **Maximum Density Filter**
    This filter is used to homogenize the density of a point cloud by rejecting a sub-sample of points in high-density regions.Points are only considered for rejection if they exceed a density threshold, otherwise they are preserved.
    __Required descriptors:__ `densities`   
    __Output descriptor:__ none 
    ![](/images/lidar-odometry/libpointmatcher/max_dens_before.png)
    ![](/images/lidar-odometry/libpointmatcher/max_dens_after.png)



#### Experiment
__Test Platform__:offline test and online(ranger) test
__Test Data__:24/06/2020 dataset for mapping from hengtong
__Test Algorithm__:eth-icp and pcl-icp
__Test Result__: 
##### offline test
comparison of the post poses and lidar-odometry by eth-icp
![](/images/lidar-odometry/regis_icp_eth.png)
![](/images/lidar-odometry/regis_icp_eth.png)
comparison of the post poses and lidar-odometry by icp-pcl
![](/images/lidar-odometry/regis_icp_pcl.png)
##### online test
comparison of the post poses and lidar-odometry by eth-icp
![](/images/lidar-odometry/ranger_icp_eth1.mp4.gif)
![](/images/lidar-odometry/regis_icp_eth_filter1.png)
comparison of the post poses and lidar-odometry by icp-pcl
![](/images/lidar-odometry/ranger_icp_pcl.png)