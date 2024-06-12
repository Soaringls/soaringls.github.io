# C++ Note GPT

## About Containers

### 向量（vector） 

实现原理：向量是通过动态数组实现的，底层使用连续的内存块来存储元素。当向量的容量不足以容纳新元素时，会自动分配更大的内存空间，并将原有元素复制到新的内存空间中。
 
  ```cpp
  #include <vector>
  using namespace std;
  
  vector<int> vec; // 声明一个整数向量
  
  vec.push_back(10); // 在向量尾部插入元素
  vec.push_back(20);
  
  vec.pop_back(); // 删除向量尾部的元素
  
  int size = vec.size(); // 获取向量的大小
  
  for (int i = 0; i < vec.size(); i++) {
      int element = vec[i]; // 使用下标访问向量中的元素
  }
  vec.clear(); // 清空向量中的所有元素
  ```

### 链表（list）  

实现原理：链表是由节点组成的数据结构，每个节点包含一个元素和指向下一个节点的指针。插入和删除操作在链表中的任意位置都很高效，但访问需要从头节点开始遍历链表。
  ```cpp
  #include <list>
  using namespace std;
  
  list<int> myList; // 声明一个整数链表
  
  myList.push_back(10); // 在链表尾部插入元素
  myList.push_front(5); // 在链表头部插入元素
  
  myList.pop_back(); // 删除链表尾部的元素
  myList.pop_front(); // 删除链表头部的元素
  
  int size = myList.size(); // 获取链表的大小
  
  list<int>::iterator it = myList.begin(); // 获取链表的迭代器
  while (it != myList.end()) {
      int element = *it; // 使用迭代器访问链表中的元素
      ++it;
  }
  ```

### 队列（queue） 

实现原理：队列是一种先进先出（FIFO）的数据结构，常见的实现方式是使用双向队列（deque）或链表（list）。
  ```cpp
  #include <queue>
  using namespace std;
  
  queue<int> myQueue; // 声明一个整数队列
  
  myQueue.push(10); // 将元素入队
  myQueue.push(20);
  
  myQueue.pop(); // 将队首元素出队
  
  int size = myQueue.size(); // 获取队列的大小
  
  while (!myQueue.empty()) {
      int frontElement = myQueue.front(); // 获取队首元素
      myQueue.pop();
  }
  ```

### 栈（stack） 

实现原理：栈是一种后进先出（LIFO）的数据结构，常见的实现方式是使用向量（vector）或双向队列（deque）。
  ```cpp
  #include <stack>
  using namespace std;
  
  stack<int> myStack; // 声明一个整数栈
  
  myStack.push(10); // 将元素压入栈顶
  myStack.push(20);
  
  myStack.pop(); // 弹出栈顶元素
  
  int size = myStack.size(); // 获取栈的大小
  
  while (!myStack.empty()) {
      int topElement = myStack.top(); // 获取栈顶元素
      myStack.pop();
  }
  ```
### 集合（set） 

实现原理：集合是一种基于二叉搜索树（如红黑树）的数据结构，其中的元素按照特定的顺序排列，并且每个元素都是唯一的。
  ```cpp
  #include <set>
  using namespace std;
  
  set<int> mySet; // 声明一个整数集合
  
  mySet.insert(10); // 插入元素
  mySet.insert(20);
  
  mySet.erase(10); // 删除元素
  
  int size = mySet.size(); // 获取集合的大小
  
  set<int>::iterator it = mySet.begin(); // 获取集合的迭代器
  while (it != mySet.end()) {
      int element = *it; // 使用迭代器访问集合中的元素
      ++it;
  }
  ```

### 映射（map） 

实现原理：映射是一种基于二叉搜索树的数据结构，其中的元素以键-值对的形式存储，每个键在映射中是唯一的，且按照键的顺序排列。
  ```cpp
  #include <map>
  using namespace std;
  
  map<string, int> myMap; // 声明一个字符串到整数的映射
  
  myMap["one"] = 1; // 插入键-值对
  myMap["two"] = 2;
  
  myMap.erase("one"); // 删除键为"one"的键-值对
  
  int size = myMap.size(); // 获取映射的大小
  
  map<string, int>::iterator it = myMap.begin(); // 获取映射的迭代器
  while (it != myMap.end()) {
      string key = it->first; // 获取键
      int value = it->second; // 获取值
      ++it;
  }
  ```


## 静态内存分配和动态内存分配

### 静态内存分配
静态内存分配是指在编译时为变量或对象分配内存空间，这些变量或对象的生命周期与程序的整个运行周期相同。静态内存分配通常发生在以下情况下：

- 全局变量：在函数之外定义的变量是全局变量，它们在程序开始执行时分配内存，在程序结束时释放内存。
- 静态变量：使用static关键字声明的局部变量称为静态变量，它们在程序的生命周期内保持存在，而不是每次函数调用时都重新分配内存。
- 静态对象：使用static关键字声明的类对象是静态对象，它们在程序的整个执行期间存在，并在程序结束时释放内存。
  
静态内存分配的主要特点是内存空间的分配和释放是自动完成的，无需手动管理。然而，静态内存分配的缺点是内存空间的大小在编译时确定，无法在运行时进行调整。

### 动态内存分配
动态内存分配是指在程序运行时根据需要分配内存空间。这种内存分配方式需要使用特定的关键字和函数来完成，包括new、delete、new[]和delete[]。

- new：用于在堆（Heap）上分配单个对象的内存空间，并返回指向该对象的指针。
- delete：用于释放通过new分配的单个对象的内存空间。
new[]：用于在堆上分配数组对象的内存空间，并返回指向数组第一个元素的指针。
- delete[]：用于释放通过new[]分配的数组对象的内存空间。
  
动态内存分配的主要特点是可以在程序运行时根据需要分配和释放内存空间。这对于处理不确定大小的数据结构或需要动态增长的数据非常有用。然而，动态内存分配需要手动管理内存，确保在不需要时释放已分配的内存，以防止内存泄漏。

需要注意的是，使用动态内存分配时应该谨慎，确保在适当的时候释放已分配的内存，以避免内存泄漏和悬挂指针等问题。可以使用智能指针（如std::shared_ptr、std::unique_ptr）等工具来辅助进行内存管理，以减少手动管理内存的负担。

### 内存泄漏和悬挂指针

- 内存泄漏：
  内存泄漏是指在程序运行过程中，分配的内存没有被正确释放或回收，导致该内存无法再被程序使用，最终耗尽系统的可用内存。这种情况通常发生在动态内存分配时，程序没有释放已分配的内存。
  ```cpp
  void func() {
      int* ptr = new int;  // 动态分配内存
      // 其他代码...
      return;  // 函数返回，但没有释放内存
  }
  
  int main() {
      while (true) {
          func();  // 反复调用函数，导致内存泄漏
      }
      return 0;
  }
  ```
  在上述示例中，函数func()动态分配了一个int类型的内存空间，但没有在函数返回前释放它。每次调用func()都会导致内存泄漏，最终导致系统内存耗尽。

- 悬挂指针：
  悬挂指针是指指向已释放或无效内存的指针。当程序中的指针继续被引用，尝试读取或写入已释放的内存时，会导致未定义的行为。
  ```cpp
  int* danglingPointer() {
      int value = 5;
      int* ptr = &value;  // ptr指向局部变量value
      return ptr;        // 返回指向局部变量的指针
  }
  
  int main() {
      int* ptr = danglingPointer();  // 获取悬挂指针
      // 其他代码...
      *ptr = 10;  // 尝试访问已释放的内存，导致未定义的行为
      return 0;
  }
  ```
  在上述示例中，函数danglingPointer()返回一个指向局部变量value的指针ptr。当函数返回后，value的生命周期结束，内存被释放。然而，main()函数中的ptr仍然指向已释放的内存。当尝试通过*ptr来访问该内存时，会导致未定义的行为。

避免内存泄漏和悬挂指针的方法包括：

- 在动态内存分配后，确保及时使用delete或delete[]释放已分配的内存。
- 避免返回指向局部变量或已释放内存的指针。
- 使用智能指针（如std::shared_ptr、std::unique_ptr）等资源管理类，可以自动处理内存的分配和释放，减少手动管理的错误。

### c++ 多态的静态和动态详解
在C++中，多态是面向对象编程的一个重要概念，它允许以统一的方式处理不同类型的对象。多态有两种形式：静态多态（编译时多态）和动态多态（运行时多态）。下面详细解释这两种多态的概念和实现方式：

### 静态多态
- 静态多态（编译时多态)
  静态多态是通过函数重载和运算符重载来实现的。在编译时，根据函数或运算符的参数类型和数量来选择合适的函数或运算符实现。这种多态的特点是在编译时确定函数或运算符的具体实现，因此也称为早期绑定。
  ```cpp
  //函数重载
  void print(int num) {
    cout << "Integer: " << num << endl;
  }
  
  void print(double num) {
      cout << "Double: " << num << endl;
  }
  
  int main() {
      print(5);        // 调用 print(int)
      print(3.14);     // 调用 print(double)
      return 0;
  }
  //运算符重载
  class Vector {
  public:
      Vector operator+(const Vector& other) {
          Vector result;
          result.x = this->x + other.x;
          result.y = this->y + other.y;
          return result;
      }
  };
  
  int main() {
      Vector v1, v2, sum;
      // ...
      sum = v1 + v2;   // 调用 operator+() 函数
      return 0;
  }
  ```
  
>静态多态的优点

   - 性能高效：静态多态在编译时确定函数或运算符的具体实现，不需要在运行时进行函数的动态绑定，因此执行效率更高。
   - 编译时类型检查：在静态多态中，编译器可以根据函数或运算符的参数类型和数量进行类型检查，以确保调用的是合适的函数或运算符实现。这提供了一定程度的安全性，可以在编译时捕获一些错误。
   - 代码可读性高：函数重载和运算符重载在静态多态中使用，可以根据函数或运算符的名称和参数列表来直观地理解代码的含义。

>静态多态的缺点：

  - 缺乏灵活性：静态多态的函数或运算符实现在编译时确定，无法在运行时根据对象的实际类型来决定调用哪个实现。这限制了对不同类型对象的灵活处理能力。
  - 需要手动处理类型：在静态多态中，需要明确指定函数或运算符的重载版本，而且需要为每个可能的类型组合提供相应的重载实现。这增加了代码的冗余和维护的复杂性。


### 动态多态
- 动态多态（运行时多态）
  动态多态通过虚函数和基类指针或引用实现。在运行时，根据实际对象的类型来调用相应的函数实现。这种多态的特点是在运行时确定函数的具体实现，因此也称为晚期绑定
  ```cpp
  class Animal {
  public:
      virtual void makeSound() {
          cout << "Animal makes a sound" << endl;
      }
  };
  
  class Cat : public Animal {
  public:
      void makeSound() override {
          cout << "Cat meows" << endl;
      }
  };
  
  class Dog : public Animal {
  public:
      void makeSound() override {
          cout << "Dog barks" << endl;
      }
  };
  
  int main() {
      Animal* animal1 = new Cat();
      Animal* animal2 = new Dog();
  
      animal1->makeSound();   // 调用 Cat 的 makeSound()
      animal2->makeSound();   // 调用 Dog 的 makeSound()
  
      delete animal1;
      delete animal2;
  
      return 0;
  }
  ```
  在上面的示例中，通过将Cat和Dog对象的指针赋值给Animal类型的指针，我们可以通过Animal指针来调用makeSound()函数。由于makeSound()函数在基类中被声明为虚函数，并在派生类中进行重写，所以在运行时根据实际对象的类型来调用相应的函数实现，实现了多态性。

>动态多态的优点：

  - 灵活性和扩展性：动态多态允许在运行时根据对象的实际类型来调用相应的函数实现，使得程序可以更灵活地处理不同类型的对象。这为程序的扩展和变化提供了更大的空间。
  - 多态性：动态多态使得基类指针或引用可以指向派生类的对象，并调用相应的虚函数实现。这使得面向对象编程中的多态特性得以实现，能够以统一的方式处理不同类型的对象。

>动态多态的缺点：

  - 运行时开销：动态多态需要在运行时进行函数的动态绑定，这会引入一定的运行时开销。在调用虚函数时，需要额外的查找虚函数表来确定实际的函数实现。
  - 缺乏编译时类型检查：在动态多态中，编译器无法在编译时检查调用的函数是否存在或参数类型是否正确。这意味着一些错误只能在运行时被检测到。
综上所述，静态多态具有高效性、编译时类型检查和代码可读性高的优点，但缺乏灵活性和扩展性；而动态多态具有灵活性、扩展性和多态性的优点，但有运行时开销和缺乏编译时类型检查的缺点。选择使用哪种多态取决于具体的需求和设计考虑。