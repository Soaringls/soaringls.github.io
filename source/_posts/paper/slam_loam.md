---
title:Note after reading paper of loam
date: 2020-11-09 10:29:34
mathjax: true
categories:
  - paper
---

### Assume
- lidar is pre-calibrated
- angular and linear velocities of the lidar are smooth and continuous over time without abrupt changes
  
### Feature Point Extraction
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
   c > threshold, &  \text{dege points} \\
   c < threshold, &  \text{planar points} 
   \end{cases}
   $$

   - we try to avoid points whose surrounded points are selected,or points on local planar surfaces that are roughly parallel to the laser beams are usually considered as unreliable.
   - we also try to avoid points that are on boundary of occluded regions

**Conclusion**
feature points are selected as edge points starting from the maximum $c$ value, and planar points starting from the minimum $c$ value, and if a point is selected,
- The number of selected edge points or planar points cannot exceed the maximum of the subregion
- None of its surrounding point is already selected
- It cannot be on a surface patch that is roughly parallel to the laser beam, or on boundary of an occluded region.
### Find Feature Point Correspondence
The odometry algorithm estimates motion of the lidar within a sweep(frame),Let $t_k$be  the starting  time of a sweep $k$. At the end of each sweep, the point cloud perceived during the sweep,$P_k$, is reprojected to time stamp $t_{k+1}$.we denote the reprojected sweep(frame) as $\bar{P_{k}}$.During the next sweep $k+1$, $\bar{P_{k}}$ is used together with the newly received point cloud $P_{k+1}$, to estimate the motion of the lidar.