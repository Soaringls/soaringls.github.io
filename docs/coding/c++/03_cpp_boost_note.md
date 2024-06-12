# Boost usage note

## boost序列化
### 序列化的基本原理
序列化就是将一个对象的数据保存到一个文件中，以便在需要的时候再恢复。序列化的过程一般分为两个步骤：
1. 序列化：将对象的数据保存到一个流中，流可以是文件、内存、网络等。
2. 反序列化：从流中读取对象的数据，恢复对象。


### loading and dump(boos archive)
```cpp
/*binary archive:load and dump so simple,deps:"@boost//:archive"*/
#include <boost/archive/text_iachive.hpp>
#include <boost/archive/text_oachive.hpp>
#include <boost/archive/binary_iachive.hpp>
#include <boost/archive/binary_oachive.hpp>

struct PatchPixelInfo{
    bool base_type_data = false;
    T1 self_type1;
    T2 self_type2;
    private:
      friend class boost::serialization::access;
      template<typename Achive>
      void serialize(Achive& ar, const unsigned int version){
          ar& base_type_data;
          ar& self_type1;
          ar& self_type2;
      }
};
//Notice: 只能适用于基础数据类型和自定义类型(需要像PatchPixelInfo一样重写系列化接口)
//Notice: 不使用google-protobuf类型数据的保存和加载
//dump
template<typename Tvalue>
void DumpMesgs(const std::string& filename,const Tvalue& output){
    std::ofstream ofs(filename);
    if(ofs.is_open()){
        // boost::archive::text_oarchive oa(ofs);
        boost::archive::binary_oarchive oa(ofs);
        oa<<output;
        ofs.close();
    }
    
}
//loading
template<typename T>
void LoadMesgs(const std::string& filename, T* input){
    std::ifstream ifs(filename);
    if(ifs.is_open()){
        // boost::archive::text_iarchive ia(ifs);
        boost::archive::binary_iarchive ia(ifs);
        is>> *input;
        ifs.close();
    }
}
```
### boost共享内存(reference from cybertron)
[参考博客:boost共享内存-基础](https://blog.csdn.net/qq_23350817/article/details/83418975)

[参考博客:boost共享内存-托管共享内存及同步](https://blog.csdn.net/qq_23350817/article/details/83418981)
#### 使用demo
```cpp
#include <boost/interprocess/shared_memory_object.hpp> 
#include <boost/interprocess/mapped_region.hpp> 
#include <iostream> 

int main() 
{ 
  boost::interprocess::shared_memory_object 
       shdmem(boost::interprocess::open_or_create, 
              "Highscore", 
              boost::interprocess::read_write); 
  shdmem.truncate(1024); 
  boost::interprocess::mapped_region region(shdmem, boost::interprocess::read_write); 
  std::cout << std::hex << "0x" << region.get_address() << std::endl; 
  std::cout << std::dec << region.get_size() << std::endl; 
  boost::interprocess::mapped_region region2(shdmem, boost::interprocess::read_only); 
  std::cout << std::hex << "0x" << region2.get_address() << std::endl; 
  std::cout << std::dec << region2.get_size() << std::endl; 
}
```
#### 使用共享内存写入并读取一个数字
```cpp
#include <boost/interprocess/shared_memory_object.hpp> 
#include <boost/interprocess/mapped_region.hpp> 
#include <iostream> 

int main() 
{ 
  boost::interprocess::shared_memory_object 
        shdmem(boost::interprocess::open_or_create, 
               "Highscore", 
                boost::interprocess::read_write); 
  shdmem.truncate(1024); 
  boost::interprocess::mapped_region region(shdmem, boost::interprocess::read_write); 
  int *i1 = static_cast<int*>(region.get_address()); 
  *i1 = 99; 
  boost::interprocess::mapped_region region2(shdmem, boost::interprocess::read_only); 
  int *i2 = static_cast<int*>(region2.get_address()); 
  std::cout << *i2 << std::endl; 
} 
```