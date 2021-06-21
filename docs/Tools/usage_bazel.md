# Usage Bazel

### bazel build
```sh
bazel build //main:hello-world
bazel build //offboard/.../pose_graph_mapping:test
 
#Run special GTest"TEST(A, func1)"
./bazel-bin/../test --gtest_filter=A.func1
```
- 编译并自动运行
  ```sh
  bazel run -c opt offboard/mapping/pose_graph_mapping/match_visualization/match_visualization_main -- \
        --run_name=20210513_101822_Q8007  --start_time=3928  \
        --run_name2=20210514_160135_Q8007 --start_time2=1509 \
        --use_smooth \
        --map=wuhan_dongfeng \
        --read_params_from_txt_file=true  \
        --gnss_strict_good
  ```