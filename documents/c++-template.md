---
title: c++-模板的使用
date: 2020-07-08 11:07:05
mathjax: true
tags: 
  - programing
  - c++
---
仅以记录工作上遇到的耽误了些许时间的哪些坑...
<!-- more -->
### 坑1-类成员模板函数在源文件(cc文件)中实现后竟然忘记实例化声明...
类的成员模板函数使用:
1. 成员模板的函数的实现放到头文件
   ```cpp
   //test.h
   class Test{
       public:
         Test()=default;
         ~Test()=default;
         
         template<typename T>
         bool CalRobustScore(const typename std::vector<T>& data, double& score);
   };
   //成员模板实现于头文件中
   template<typename T>
   bool CalRobustScore(const typename std::vector<T>& data, double& score){
       ...
   }
   ```
2. 成员模板的函数的实现放到源文件，但必须实例化声明
   ```cpp
   //test.h
   class Test{
       public:
         Test()=default;
         ~Test()=default;
         
         template<typename T>
         bool CalRobustScore(const typename std::vector<T>& data, double& score);
   };
   
   //test.cc
   //成员模板实现于源文件中
   template<typename T>
   bool CalRobustScore(const typename std::vector<T>& data, double& score){
       ...
   }
   //然后必须实例化声明，否则该函数被调用是将找不到
   template bool CalRobustScore<double>(const typename std::vector<double>& data, double& score);
   template bool CalRobustScore<float>(const typename std::vector<float>& data, double& score);
   ... //其他可能的类型
   ```