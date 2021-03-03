### loam
#### 特点
优点：
- 充分利用机械式旋转式雷达原理和点云分布特性
- 特征匹配: scan2scan->speed
         scan2map->accuracy
  >基于特征的配准确保计算快速
- imu-去除点云畸变
缺点: 没有实现回环检测以消除累计漂移
#### 步骤
- 特征点提取
  - 点云->16*scanline
  - 每个scanline计算曲率/平滑度: 每个点左右领域r范围(如5个点,r=5)内邻近点的range之和为SumRangeNeighbors,当前点range为curRange，则当前点的曲率为 
$$
curvature = (SumRangeNeighbors-r*curRange)*(SumRangeNeighbors-r*curRange)
$$
  - 为了使得环境中特征点均匀分布,每个scanline的点均分为6段,每段的点按照曲率升序排序,然后从每段的点中区分角点(曲率较大)和平面点(曲率较小),从每段点钟选取限定个数的角点和面点(论文中每段最多2个角点、4个面点)
    - 避免选取扫到几乎和`laser beam` 平行的平面上的点
    - 避免选取断裂面的边点
- 找特征点的对应点
  - a