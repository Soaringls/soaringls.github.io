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
  - 针对`t+1`时刻线和面特征的每个特征点,在`t`时刻对应的线或面特征点集中寻找一定个数对应的最邻近点
  - `t+1`时刻线特征点对应寻找`t`时刻的2个最邻近的线特征点(且2个邻近的特征点不能在同一个scanline上,除非线特征在scan line plane,但这样的话线特征会退化为scan line plane上的一条直线)
    **优化细则**
    - 计算当前特征点$X$到对应特征点$X1$、$X2$构成线的距离$d$  原理为三角形面积的计算(向量叉乘 == 边长*高，高即为点到线距离)
    - 求$d$对当前特征点$X$的导数$(lax,lby,lcz)$,表示距离$d$在特征点$X$三维方向的变化率
    - 构建递减函数$s=1-1.2\cdot|d|$,求系数$s$以作为当前特征点$X$的$(lax,lby,lcz)$及距离的权重(距离$d$越大权重越小，s接近0时候当前特征点不参与优化)
      ```cpp
      ...
      float d = a012 / l12;//计算点(x0,y0,z0)到直线(x1,y1,z1)、(x2,y2,z2)的距离
      float s = 1; 
      s = 1 - 1.2 * fabs(d); 
      // 若s太小或者为负数,则本匹配点失效对之后优化不贡献约束
      // la lb lc 为点到直线距离相对于当前特征点坐标的偏导数.
      if (s > 0.1 && d != 0) {
        PointT coeff;
        coeff.x = s * la;
        coeff.y = s * lb;
        coeff.z = s * lc;
        coeff.intensity = s * d;//intensity存储range
        laser_cloud_ori_->push_back(corner_points_sharp_->points[pidx]);//添加当前特征点参与优化
        coeff_sel_->push_back(coeff);
      }
      ...
      ```
    - 优化要点详情
      ```cpp
      ...
      for (int i = 0; i < point_num; i++) {//point_num=laser_cloud_ori_->size()
        PointT point_ori = laser_cloud_ori_->points[i];//source-frame-corner中每个特征点
        //每个source中特征点P到target's line的dist对P的导数,intensity存储距离
        PointT coeff = coeff_sel_->points[i];
        //ary atx  atz为loss函数即dist对T, 即transform_cur_中的欧拉角求导
        float ary = (b1 * point_ori.x + b2 * point_ori.y - b3 * point_ori.z + b4) * coeff.x + (b5 * point_ori.x + b6 * point_ori.y - b7 * point_ori.z + b8) * coeff.z;
        float atx = -b5 * coeff.x + c5 * coeff.y + b1 * coeff.z;
        float atz = b7 * coeff.x - srx * coeff.y - b3 * coeff.z;
        float d2 = coeff.intensity;
        matA(i, 0) = ary;//matA即为Jacobian  point_num*3  
        matA(i, 1) = atx;
        matA(i, 2) = atz;
        matB(i, 0) = -0.05 * d2;//point_num*3
      }
      //增量方程 J* delta_X = -J * f(x)
      matAt = matA.transpose(); //matA 3*n
      matAtA = matAt * matA;    //JT*J 3*3
      matAtB = matAt * matB;    //-J * f(x) 3*1
      delta_X = matAtA.colPivHouseholderQr().solve(matAtB);//delta_X 3*1, matAtA*delta_X=matAtB
      if (iter_counter == 0) { 
        ...
        Eigen::SelfAdjointEigenSolver<Eigen::Matrix<float, 3, 3>> esolver(matAtA);
        eigen_values = esolver.eigenvalues().real();//递增
        eigen_vectors = esolver.eigenvectors().real();
        eigen_vectors2 = eigen_vectors;

        is_degenerate_ = false;
        float eign_thre[3] = {10, 10, 10};
        for (int i = 2; i >= 0; i--) {
          if (eigen_values(0, i) < eign_thre[i]) {
            for (int j = 0; j < 3; j++) eigen_vectors2(i, j) = 0;//某方向特征值小于阈值则归0,表示退化
            is_degenerate_ = true;
          } else { break; }
        }
        matrix_eigenvectors = eigen_vectors.inverse() * eigen_vectors2;//单位阵,退化时退化方向值为0
      }
      if (is_degenerate_) { 
        delta_X = matrix_eigenvectors * delta_X;//退化时只更新delta_X中特征值不为0的量,特征值为0的量不更新
      }
      transform_cur_[1] += delta_X(0, 0);//delta_X 3*1  angle-yaw
      transform_cur_[3] += delta_X(1, 0);//translation delta_x
      transform_cur_[5] += delta_X(2, 0);//translation delta_y
      ...
      ```
  - `t+1`时刻面特征点对应寻找`t`时刻的3个最邻近的面特征点
