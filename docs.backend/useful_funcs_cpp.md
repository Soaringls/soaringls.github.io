---
title: Some useful functions
data: 2020-11-1 13:23:23
categories:
  - coding
---
# Strategy Pattern
## Intent
- Define a family of algorithms, encapsulate each one, and make them interchangeable. Strategy lets the algorithm vary independently from the clients that use it.
- Capture the abstraction in an interface, bury implementation details in derived classes.
<!-- more -->

### std::adjacent_find
```cpp
#include <algorithm>
#include <iostream>
#include <vector>
#include <functional>
 
int main()
{
    std::vector<int> v1{0, 1, 2, 3, 40, 40, 41, 41, 5};
 
    auto i1 = std::adjacent_find(v1.begin(), v1.end());
 
    if (i1 == v1.end()) {
        std::cout << "no matching adjacent elements\n";
    } else {
        std::cout << "the first adjacent pair of equal elements at: "
                  << std::distance(v1.begin(), i1) << '\n';
    }
 
    auto i2 = std::adjacent_find(v1.begin(), v1.end(), std::greater<int>());
    if (i2 == v1.end()) {
        std::cout << "The entire vector is sorted in ascending order\n";
    } else {
        std::cout << "The last element in the non-decreasing subsequence is at: "
                  << std::distance(v1.begin(), i2) << '\n';
    }
}
```
Output is:
```
The first adjacent pair of equal elements at: 4
The last element in the non-decreasing subsequence is at: 7
```
## useful function from mentor
### about file utils
- IsSameFile
```cpp
bool IsSameFile(const std::string& file1, const std::string& file2){
    auto auto_close = [](int *fd_ptr){ ::close(*fd_ptr); }

    //get file descriptor id
    int fd = open(file1.c_str(), O_RDONLY);
    if(fd < 0) return false;
    std::unique_ptr<int, void(*)(int *)> auto_close_fd(&fd, auto_close);

    struct stat statbuf;
    int err = fstat(fd, statbuf);
    if(err < 0) return false;

    //get file2 descriptor id
    int fd2 = open(file2.c_str(), O_RDONLY);
    if(fd2 < 0) return false;
    std::unique_ptr<int/*type*/, void(*)(int *)/*deleter*/> auto_close_fd2(&fd2, auto_close);

    struct stat statbuf2;
    int err2 = fstat(fd2, statbuf2);
    if(err2 < 0 || statbuf.st_size != statbuf2.st_size) return false;//standard 1

    auto auto_munmap = std::bind(munmap/*linux func*/, std::placeholders::_1, statbuf.st_size);

    std::unique_ptr<void, decltype(auto_munmap)> ptr1(
           mmap(nullptr, statbuf.st_size, PROT_READ, MAP_SHARED, fd, 0),
           auto_munmap);
    if(ptr1.get() == MAP_FAILED) return false;

    std::unique_ptr<void, decltype(auto_munmap)> ptr2(
           mmap(nullptr, statbuf.st_size, PROT_READ, MAP_SHAEED, fd2, 0),
           auto_munmap);
    if(ptr2.get() == MAP_FAILED) return false;
    /*
    memcmp对ptr1 和 ptr2的 前statbuf.st_size字符进行比较
    */
    return memcmp/*c lib*/(ptr1.get(), ptr2.get(), statbuf.st_size) == 0;
}
```