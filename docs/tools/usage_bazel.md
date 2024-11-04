# Usage Bazel

### bazel build
```sh
bazel build //main:hello-world
bazel build //offboard/.../pose_graph_mapping:test

#debug编译
bazel build //offboard/mapping/pose_graph_mapping/lidar_odometry:pm_test  --compilation_mode=dbg \
    -s \ #-s显示编译细节
    --config=asan #编译器配置,编译相对较慢,直接运行程序会提示错误信息(gdb启动此时没有stack信息)
 
#Run special GTest"TEST(A, func1)"
./bazel-bin/../test --gtest_filter=A.func1


bazel test ... -- -experimental/...
bazel query  //onboard/...|grep cpplint$|xargs bazel test 
bazel query  //offboard/...|grep cpplint$|xargs bazel test
```
- 编译并自动运行
  ```sh
  bazel build -c dbg  //offboard/mapping/pose_graph_mapping/lidar_odometry:pm_test
  bazel run -c opt offboard/mapping/pose_graph_mapping/match_visualization/match_visualization_main -- \
        --run_name=20210513_101822_Q8007  --start_time=3928  \
        --run_name2=20210514_160135_Q8007 --start_time2=1509 \
        --use_smooth \
        --map=wuhan_dongfeng \
        --read_params_from_txt_file=true  \
        --gnss_strict_good \
        --vantage_server_addr=0.0.0.0:65001 #先启动vantage
  ```
### 引入第三方库(clipper)

#### 获取repo下载地址
   `https://github.com/mit-acl/clipper/archive/764b2d9a752af4ad9da03df1490baa0409dc5baa.zip`

#### 生成文件的sha256值
   ```sh
   shasum -a  256  clipper-764b2d9a752af4ad9da03df1490baa0409dc5baa.zip  #cmd
   # output:
   f0a592e5419e22e8d6bd479348bbca9eb309a966bec0f2f8145089e71e1cb633  clipper-764b2d9a752af4ad9da03df1490baa0409dc5baa.zip
   ```

#### 在WORKSPACE文件中引入
  ```sh
  #bazel/workspace.bzl 文件中引入
  load("//third_party/clipper:workspace.bzl", clipper = "repo")
  #...
  clipper()
  #...
  ```