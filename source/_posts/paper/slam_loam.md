---
title: Note after reading paper of loam
date: 2020-10-09 10:29:34
mathjax: true
categories:
  - paper
  - algorithm
tag:
  - slam
---
this blog conclud from **loam(Ji Zhang),LeGO-LOAM&LIO-SAM(Tixiao Shan)**
State estimation, localization and mapping are fundamental prerequisites for a successful intelligent mobile robot,required for feedback control, obstacle avoidance, and planning, among many other capabilities.Using **vision-based** and **lidar-based** sensing,great efforts have been devoted to achiving high-performance real-time simultaneous localization and mapping(SLAM) that can support a mobile robot's six degree-of-freedom state estimation.
<!-- more -->
Vision-based methods typically use a monocular or stereo camera and triangulate features across successive images to determine the camera motion.Although vision-based methods are especially suitable for palce recognition,their sensitivity to initialization,illumination and range make them unreliable when they alone are used to supportan autonomous navigation system.
On the other hand, lidar-based methods are largely invariant to illumination change,Especially with the availability of long-range,high-resolution 3D liar,becomes more suitable to directly capture the fine details of an environment in 3D space.Therefor there was researchs among loam,lego-loam and lio-sam, those paper focuses on lidar-based state estimation and mappnig methods.

| method       | strenght                                                                                                    | weakness                                                                  |
| ------------ | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| vision-based | --more suitable for place recognition<br>--better in loop-closure detection                                 | --sensitive to illumination<br>--view point change may make it unreliable |
| lidar-based  | --work normally at night<br>--captrure more details about environment at long ranges<br>--bigger angle-view | a                                                                         |

# Desc about loam lego-loam lio-sam
| method    | strength                                                                                                                                                                                                                                                                                                                                                          | weakness                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | IMU                                                                                                                                                                                         |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| loam      | --low-drift and real-time<br>--correct the motion distortion of pointcloud<br>--feature-based scan matching: edge with edge and planar with planar to ensure fats computation becase of its less computational resources requirement<br>--good strategy: coarse processing  at high frequency to estimate veocity, fine processing at low frequency to create map | --saving data in a global voxel map,online optimization process will less efficient when the global voxel map becomes dense in a feature-rich areas<br>--difficult to perform loop closure detection and incorporate other absolute measurements,e.g GPS for pose correction<br>--loam suffers from drift in large-scale test, as it is a scan-matching based method at its core<br>--not very universal to different lidars:the method of extracting features are integrated with the rotating lidar tightly | --de-skew the lidar scan,that is motion compensator<br>--provide a motion prior for scan-matching<br>--**loosely-coupled**:IMU is not involved in the optimization process of the algorithm |
| lego-loam | --lightweight and ground-optimized lidar odom<br>--two step L-M optimization computes pose transformation separately<br>--add loop closure                                                                                                                                                                                                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | same as loam                                                                                                                                                                                |
| lio-sam   | --a tightly-coupled lidar inertial odometry framework built atop a factor graph,which is suitable for multi-sensor fusion and global optimization<br>--an efficient,local sliding window-based scan-matching approach that enables real-time performance by registering selectively chosen new keyframes to a fixed-size set of prior sub-keyframes               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |


## lidar motion compensator
A scan's point cloud is often skewed because of the rotation mechanism of modern 3D lidar and sensor motion.Solely using lidar for pose estimation is not ideal since registration using skewed pointclouds or features will eventually cause large drift.
Therefore, lidar is typically  used in conjunction with other sensors, such as GPS and IMU, for state estimation and ampping.
# LOAM
## Assume
- lidar is pre-calibrated
- angular and linear velocities of the lidar are smooth and continuous over time without abrupt changes
  
## Feature Point Extraction
we select feature point that are on sharp edges and planar surface patches, Let $i$ be a point in $P_k$, and let $S$ be the set of consecutive points of $i$ returned by the laser scanner in the same scan.
1. Calculate the smoothness **$c$** of the local surface at point i, where $i \in P_k$
   $$
   c = \frac{1}{|S|\cdot\|X^L_{(k,i)}\|}\cdot\|\sum_{j\in S,j\neq i}(X^L_{(k,i)} - X^L_{(k,j)})\|\tag{1}
   $$
2. The points in a scan are sorted based on the $c$ values.
   To evenly distribute the feature points within the environment,we separate a scan to four identical subregions.Each subregion can provide maximally 2 edge points and 4 planar points
   $$
   bool(c)= 
   \begin{cases}
   c > threshold, &  \text{dege points} \\\\
   c < threshold, &  \text{planar points} 
   \end{cases}
   $$

   - we try to avoid points whose surrounded points are selected,or points on local planar surfaces that are roughly parallel to the laser beams are usually considered as unreliable.
   - we also try to avoid points that are on boundary of occluded regions

**Conclusion**
feature points are selected as edge points starting from the maximum $c$ value, and planarpoints starting from the minimum $c$ value, and if a point is selected,
- The number of selected edge points or planar points cannot exceed the maximum of thesubregion
- None of its surrounding point is already selected
- It cannot be on a surface patch that is roughly parallel to the laser beam, or on boundaryof an occluded region.
  
## Find Feature Point Correspondence
The odometry algorithm estimates motion of the lidar within a sweep(frame),Let $t_k$be  the starting  time of a sweep $k$. At the end of each sweep, the point cloud perceived during the sweep,$P_k$, is reprojected to time stamp $t_{k+1}$.we denote the reprojected sweep(frame) as $\bar{P_{k}}$.During the next sweep $k+1$, $\bar{P_{k}}$ is used together with the newly received point cloud $P_{k+1}$, to estimate the motion of the lidar.

   | raw frame                               | corrected frame                                                    | edge pts                                              | planar pts                                              |
   | :-------------------------------------- | :----------------------------------------------------------------- | :---------------------------------------------------- | :------------------------------------------------------ |
   | $P_k$<br>during [$t_k,t_{k+1}$]         | $\bar{P}\_k$<br>by reprojected $P_k$to timesatmp $t_{k+1}$         | $\mathcal{E}_k$<br>edge pts from$\bar{P}_k$           | $\mathcal{H}_k$<br>planar pts from$\bar{P}_k$           |
   | $P_{k+1}$<br>during [$t_{k+1},t_{k+2}$] | $\bar{P}\_{k+1}$<br>by reprojected $P_{k+1}$to timesatmp $t_{k+1}$ | $\mathcal{E}\_{k+1}$<br>edge pts from$\bar{P}\_{k+1}$ | $\mathcal{H}\_{k+1}$<br>planar pts from$\bar{P}\_{k+1}$ |

- Source of Feature Points
  - At each iteration,$\mathcal{E}\_{k+1}$ and $\mathcal{H}\_{k+1}$ are reprojected point sets at the beginning of the sweep $\bar{P}\_{k+1}$by using currently estimated transform.
  - For each point in $\mathcal{E}\_{k+1}$ and $\mathcal{H}\_{k+1}$,we are going to find the closest neighbor point in $\bar{P}\_k$,which is stored in a 3D KD-tree for fast index.
- Find the closest points in $\mathcal{E}\_{k}$ and $\mathcal{H}\_{k}$ for each point of $\mathcal{E}\_{k+1}$ and $\mathcal{H}\_{k+1}$
  - find closest edge points in $\mathcal{E}\_{k}$ for each point of $\mathcal{E}\_{k+1}$
    let $X^L_{(k+1,i)}$denote the point $\mathcal{i} \in \mathcal{E}\_{k+1}$,which is in LidarCoordinateSystem{$L$}
    the edge line is represented by two points,points $j \in \mathcal{E}\_k$ and $l \in \mathcal{E}\_k$ are closest neighbor of $i$ in consecutive scans.<br>
    **Notice** we particularly require that $j$ and $l$ are from different scans considering that a single scan cannot contain more than one points from the same dege line

  - find closest planar points in $\mathcal{H}\_{k}$ for each point of $\mathcal{H}\_{k+1}$
    the planar patch is represented by three points,similar to last,we find the closest neighbor of $i$ in $\bar{P}_k$,denote as $j$,$l$,$m$<br>
    **Notice** about $j$,$l$,$m$,two of them are on the same scan, another is in consecutive scans,This guarantees that the three points are **non-collinear**
  - compute the distance between every feature point of $\bar{P}\_{k+1}$ to the closest neighbor points of $\bar{P}\_{k}$<br>
    **Notice** all points in the formula ($\mathcal{2}$) and ($\mathcal{3}$) is the coordinates in {$L$}.
   $$
   d\varepsilon = \frac{|(\widetilde{X}^L_{(k+1,i)}- \bar{X}^L_{(k,j)})\times (\widetilde{X}^L_{(k+1,i)}- \bar{X}^L_{(k,l)})|}{|\bar{X}^L_{(k,j)} - \bar{X}^L_{(k,l)}|} .\text{distance of point to line} \tag{2} 
   $$
   $$
   d_{\mathcal{H}} = \frac{|(\widetilde{X}^L_{(k+1, i)} - \bar{X}^L_{(k,j)})\cdot((\bar{X}^L_{(k,j)} - \bar{X}^L_{(k,l)})\times(\bar{X}^L_{(k,j)} - \bar{X}^L_{(k,m)}))|}
   {|(\bar{X}^L_{(k,l)} - \bar{X}^L_{(k,j)})\times(\bar{X}^L_{(k,m)} - \bar{X}^L_{(k,j)})|}.\text{distance of point to planar}\tag{3}
   $$
 - Motion Estimation TODO
   - Corrected every point for a sweep
   - Motion estimation between two consecutive sweep
  
# LIO-SAM
## Assume
1. assume nonlinear motion model for point cloud de-skew,estimate the sensor motion during a lidar scan using raw IMU measurements
2. the estimated motion above also serve as an intial guess for lidar odometry optimization
3. the lidar-odometry result above is then used to estimate the bias of the IMU in the factor graph.