---
title: icp算法的20年
date: 2020-07-08 11:07:05
mathjax: true
tags: 
  - pointcloud
  - registration
---

使用方法
<!-- more -->

datafilter: 不同降采样方法去除噪声等以抑制传感器噪声
matcher: 最邻近搜索方法

### matcher
KDTreeMatcher:
{"knn", "number of nearest neighbors to consider it the reference", "1", "1", "2147483647", &P::Comp<unsigned>},
				{"epsilon", "approximation to use for the nearest-neighbor search", "0", "0", "inf", &P::Comp<T>},
				{"searchType", "Nabo search type. 0: brute force, check distance to every point in the data (very slow), 1: kd-tree with linear heap, good for small knn (~up to 30) and 2: kd-tree with tree heap, good for large knn (~from 30)", "1", "0", "2", &P::Comp<unsigned>},
				{"maxDist", "maximum distance to consider for neighbors", "inf", "0", "inf", &P::Comp<T>}