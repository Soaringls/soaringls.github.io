### 计算点云的特征分布(即特征值和特征向量)
- func1-from ct-icp
   ```cpp
   struct Neighborhood{
       EIGEN_MAKE_ALIGNED_OPERATOR_NEW
       Eigen::Vector3d center = Eigen::Vector3d::Zero();
       Eigen::Vector3d normal = Eigen::Vector3d::Zero();
       Eigne::Matrix3d data_covariance = Eigne::Matrix3d::Identity();
       double a2D = 1.0; //Planarity coefficient
   };
   //Eigen::SelfAdjointEigenSolver<Eigen::Matrix3d> esolver(data_covariance);
   Neighborhood ComputeNeighborhoodDistribution(const std::vector<Eigen::Vector3d>& points){
       Neighborhood result;
       Eigen::Vector3d& center = result.center;
       for(const auto& pt : points){
           center += pt;
       }
       center /= points.size();
       //compute data's covariance
       for(const auto& pt : points){
           for(int row = 0; row < 3; row++){
               for(int col = row; col < 3; col++){
                   result.data_covariance(row, col) += (pt(row) - center(row)) * (pt(col) - center(col));
               }
           }
       }
       /*
          x   y   z 
       x  xx  xy  xz
       y  _   yy  yz
       z  _   _   zz
       */
      result.data_covariance(1, 0/*yx*/) = result.data_covariance(0, 1/*xy*/);
      result.data_covariance(2, 0/*yx*/) = result.data_covariance(0, 2/*xy*/);
      result.data_covariance(2, 1/*yx*/) = result.data_covariance(1, 2/*xy*/);
      
      //eigen value sort ascending-up, 平面的话最小的为法向量
      Eigen::SelfAdjointEigenSolver<Eigen::Matrix3d> solver(result.data_covariance); 
      result.normal = Eigen::Vector3d(solver.eigenvectors().col(0).normalized());

      Eigen::Vector3d eigen_value = solver.eigenvalues();
      result.a2D = (std::sqrt(std::abs(eigen_value[1])) - std::sqrt(std::abs(eigen_value[0])))/std::sqrt(std::abs(eigen_value[2])); //->1,then plane is better
      
      if(std::abs(result.a2D - 1) < std::numeric_limits<double>::epsilon()){
          LOG(ERROR)<<"FOUND NAN";
          throw std::runtime_error("error");
      }
      return result;
   }
   ```