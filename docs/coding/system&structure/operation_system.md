### 程序流程
**预编译->编译和优化->汇编->链接**
- 预编译:引用的头文件包含到源代码
- static and shared libs
  - static:更快、更易用、更大
  - shared:需要安装、小、相比static慢、系统中配置文件`/etc/ld.so.conf`是动态链接库的搜索路径配置文件
    - `ldconfig -p`