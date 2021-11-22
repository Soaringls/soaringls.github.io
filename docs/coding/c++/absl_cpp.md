### string
- str join
  ```cpp
  std::string lidar_dir_ = absl::StrFormat("%s/%s", pt_dir_full_, "/lidar/");
  std::string file_data_posesigma =
      absl::StrCat(collect_data_dir_, "/", expand_prefix, kPoseSigma);
  ```
- str split
  ```cpp
  std::vector<absl::string_view> msg_arr = absl::StrSplit(msg, ";");
  ```
### type convertor
- str2number
  ```cpp
  //...
  const std::string str = ...;
  uint64 id;
  if(!absl::SimpleAtoi(str, id)) continue;
  ///...
  ```
### time
- `absl::ToUnixMicros(absl::Now())`
  