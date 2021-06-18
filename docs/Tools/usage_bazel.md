# Usage Bazel

### bazel build
```sh
bazel build //main:hello-world
bazel build //offboard/.../pose_graph_mapping:test
 
#Run special GTest"TEST(A, func1)"
./bazel-bin/../test --gtest_filter=A.func1
```