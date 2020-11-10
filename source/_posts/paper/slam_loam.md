---
title: Note after reading paper of loam
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
    the edge line is represented by two points,points $j \in \mathcal{E}\_k$ and $l \in \mathcal{E}\_k$ are closest neighbor of $i$ in consecutive scans.
    **Notice** we particularly require that $j$ and $l$ are from different scans considering that a single scan cannot contain more than one points from the same dege line

  - find closest planar points in $\mathcal{H}\_{k}$ for each point of $\mathcal{H}\_{k+1}$
    the planar patch is represented by three points,similar to last,we find the closest neighbor of $i$ in $\bar{P}_k$,denote as $j$,$l$,$m$
    **Notice** about $j$,$l$,$m$,two of them are on the same scan, another is in consecutive scans,This guarantees that the three points are **non-collinear**
  - compute the distance between every feature point of $\bar{P}\_{k+1}$ to the closest neighbor points of $\bar{P}\_{k}$
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
