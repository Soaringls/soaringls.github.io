---
title: cloud segmentation and filtered by hdmap
date: 2020-07-12 14:19:22
categories: 
  - autonomous
  - pointcloud
tags:
  - segmentation
  - pointcloud
  - hdmap
---
基本流程：
1. 分割地面点和非地面点
2. 基于非地面点进行点云分割
3. 实时加载hdmap将位于道路上的分割结果进去滤出(亦可通过tracking将动态障碍物滤除)
<!-- more -->
#### 整体概览
1. 左下角为原始点云数据
2. 右下角为检测的地面点云
3. 左上角为分割的结果(已根据hdmap滤出位于道路上的动态障碍物)
4. 右上角为滤出动态障碍物后点云
![general view of the lidar segmentation](images/cloud_segmentation/hdmap_filter/general_viewer.gif)
#### 地面的分割
采用极坐标投影网格和平面拟合的方法
![ground detect,and the objects on road is filtered by hdmap](images/cloud_segmentation/hdmap_filter/ground_detect.mp4.gif)
![the detail of ground detection](images/cloud_segmentation/hdmap_filter/ground_detect.png)
#### 点云聚类
采用网格投影->膨胀->连通分析->收缩
![](images/cloud_segmentation/hdmap_filter/objs_filtered0_byhdmap.mp4.gif)
![vechicle and pedestrian filtered by hdmap](images/cloud_segmentation/hdmap_filter/objs_filtered_byhdmap.mp4.gif)
