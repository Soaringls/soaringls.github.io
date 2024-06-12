# The Essence of C++ 


## 基础
```cpp
//C字符串的复制
char *name, *_filename;
name = "asasfdasdlk";
_filename = (char*)malloc((strlen(name)+1)*sizeof(char));
strcpy(_filename, name); 
```

- 抽象类（不能实例化）：包含至少一个纯虚函数的类（子类为非抽象类则必须重写父类所有抽象方法，子类也为抽象类则可重写亦可仅仅继承抽象方法）
- 虚基类：解决多重多级继承造成的二义性问题（基类B派生了C和D，然后类F又同时继承了C和D，则类F的对象包含2个基类B的对象。若将让C和D虚继承自B则可以解决这样的问题）
- 纯虚函数：定义一个函数为纯虚函数表示函数**没有被实现（或定义）**，是为起到一个规范的作用，规范继承自这个类的人员必须实现这个函数
- 虚函数：虚函数不代表未被实现，而是为了允许基类指针调用子类的这个函数。 继承而来的虚函数可不写关键字virtual（一般最好写上）
- 纯虚析构函数：
    ```cpp
    class AWOV{
    public:
        virtual ~AWOV()=0;
    }
    AWOV::~AWOV(){} //pure virtual析构函数的定义
    ```
- 虚析构函数：带多态性质的基类应声明一个virtual析构，class带有任何virtual函数，它就应该有一个virtual析构。但如果class的设计目的不是作为基类使用或不具备多态性，则不需声明为virtual析构函数(条款7总结）
- 子类调用父类静态变量和方法->子类类名::父类静态变量或方法；父类的静态方法子类不可重写为非静态，父类的非静态方法子类亦不可重写为静态的，子类虽然可以重写父类的静态方法但是并没有多态的特性
- 常用设计模式
   >GUI->组合模式
   数据结构遍历->迭代器
   消息机制->观察者模式
   资源管理->单例模式
   ...
   工厂、装饰器、适配器

## Effecitve C++（第三版）
### 条款11. 在operato r=中处理“自我赋值” TODO（56页有疑问？？？）
 `构造/析构/赋值运算`
### 条款12. 复制对象不可遗漏其每一个成分 Copy all parts of an object
  `构造/析构/赋值运算`
  `copying函数包括copy构造函数和copy assignment操作符`
### 条款13. 以对象管理资源呢 use objects to manage resources
 `资源管理（动态分配内存、文件描述器、互斥锁...不使用时都必须归还给系统）`
   >资源取得时机便是初始化时机RAII(Resource Acquisition Is Initialization)
   >引用计数型智能指针RCSP(reference-counting smart pointer)
   >reference-counting copying

### 条款14. 资源管理类中小心copying行为
 ```cpp
 void lock(Mutex* pm);  //锁定pm所指的互斥器
 void unlock(Mutex* pm);//将互斥器解除锁定
 //Lock类管理锁
 class Lock{
 public:
    explict Lock(Mutex* pm) : mutexPtr(pm, unlock) //unlock为shared_ptr的删除器，当引用次数为0是不会删除指针所指物，而是调用指定的删除器unlock
    {
        lock(mutexPtr.get());
    }
 private:
    std::tr1::shared_ptr<Mutex> mutexPtr;
 }
 //对Lock的用法符合RAII方式
 Mutex m; //定义所需要的互斥器
 {
     ....
     Lock m1(&m); //锁定互斥器
     ....
 } //区块末尾，自动解除互斥器锁定
 ```
### 条款28. 避免返回handles指向对象内部成分
 >handles(号码牌，如引用、指针、迭代器)

### 条款29. 为“异常安全”而努力是值得的
 ```cpp
 class PrettyMenu{
 public:
    ....
    void changeBackground(std:istream& imgSrc);
    ....
 private:
    Mutex mutex;
    Image* bgImage;
    int imageChanges;
 };
 void PrettyMenu::changeBackground(std::istream& imgSrc)
 {
     Lock ml(&mutex); //借鉴条款14，获得互斥锁并确保它稍后被释放
     delete bgImage;
     ++imageChanges;
     bgImage = new Image(imgSrc);
 }
 ```
### 条款30. 透彻了解inlining的里里外外
 - 大部分编译器拒绝将太过复杂（如带有循环和递归）的函数inlining，所有的virtual函数的调用也会使inlining落空，因为virtual意味着等待到运行时才能确定调用哪个函数，而inline意味着执行前先将调用动作替换为被调函数的本体
 - 大多数inlining限制在小型、被频繁调用的函数身上，这可是日后的调试过程和二进制升级更容易，亦可使潜在的代码膨胀问题最小化，使程序的速度提升机会最大化
 - 不要只因为function templates出现在头文件，就将他们声明为inline

### 条款31. 将文件间的编译依存关系降至最低
 >建置环境（build environments）
 export允许template声明式和定义式分割与不同文件内，但支持这个关键字的编译器越来越少
 
## Excerpt from yt video
This page is the note of Bjarne's speech at Edinburgh from youtobe.
<!-- more -->
### What did/do I want?
Type safety
- Encapsulate necessary unsafe operations

Resource safety
- it's not all memory

Performance
- For some parts of almost all systems,it's important

Predictability
- For hard and soft real time

Teachability
- Complexity of code should be proportional to the complexity of the task

Readability
- People and machines("analyzability")
### Who did/do I want it for?
Primary concerns
- Systems propramming
- Embedded systems
- Resource constrained systems
- Large systems

Experts
- "c++ is expert friendly"

Novices
- "c++ is not just expert friendly"

### C++ in two lines
####  What is C++?
Direct map to hardware
- of instructions and dundamental data types
- Initially from C

Zero-Overhead abstraction
- Classes with constructors and destructors,inheritance,generic programming,functional programming techniques
- Initially from Simula

Much of the inspiration came from operating systems
What does C++ wants to be when it grows up?
- See above
- And better at it for more modern hardware and techniques
- Compatibility/stability is a feature

### Cpp is a light-weight abstraction programming language
building and using efficient and elegant abstractions
### Key strengths:
- software infrastructure
- resource-constrained applications
#### Resource Management
##### A resource is something that must be acquired and latter released
- Explicitly or implicitly
- Resource management should not be manual
  - we don't want leaks(泄露)

#### A resource should have an owner
- Usually a "handle"
- A "handle" should present a well-defined and useful abstraction

#### All the standard-library containers manage their elements
- vector
- list,forward_list(singly-linked list),...
- map,unordered_map(hash table),...
- set,multi_set,...
- string

#### Other standard-library classes manage other resoures
- Not just memory(Garbage collection is not sufficient)
- thread,lock_guard,...
- istream,fstream,...
- unique_ptr,shared_ptr,...

#### Use constructors and destructor
```cpp
template<typename T>
class Vector {
 public:
  Vector(initializer_list<T>);//vector of elements of type T
  ~Vector();
  //...
 private:
  T* elem; //pointer to elements
  int sz;  //number of  elements
};

void fct(){
    Vector<double> vd{1, 1.625, 3.14, 2.998e8};
    Vector<string> vs{"Strachey", "Richards"};
}
```
#### Pointer Misuse
>Many(most) uses of pointers in local scope are not exception safe
```cpp
void f(int n, int x){
    Gadget* p = new Gadget(n);
    //...
    if(x < 100) throw std::runtime_error("Weird!");//leak
    if(x < 200) return;                            //leak
    //...
    delete p; //I want my garbage collector!
}
```
```
But garbage collection would not release non-memory resources
Why use a "naked" pointer?
```
#### Resource Handles and Pointers
>A std::shared_ptr releases its object at when the last shared_ptr to it is destroyed
```cpp
void f(int n, int x){
    auto p = make_shared<Gadget>(n); //manage that pointer!
    //...
    if(x < 100) throw std::runtime_error("Weird!");//no leak
    if(x < 200) return;                            //no leak
    //...
}
```
**shared_ptr** provides a form of garbage collection(But I'm not sharing anything!)
>A **std::unique_ptr** releases its object at when it goes out of scope
```cpp
void f(int n, int x){
    auto p = make_unique<Gadget>(n); //manage that pointer!
    //...
    if(x < 100) throw std::runtime_error("Weird!");//no leak
    if(x < 200) return;                            //no leak
    //...
}
```
This is simple and cheap
No more expensive than a "plain old pointer"
#### Error Handling and Resources

"Resource Acquistion Is Intialization"(RAII)
1. Acquire during construction
2. Release in destructor

Throw exception in case of failure
>In particular, throw is a constructor cannot construct and object

Never throw while holding a resource **not** owned by a handle
>Never leak

In general
>Leave established invariants intact when leaving a scope

### Why do we use pointers?
And references,iterators,etc.
To represent ownership

- **Don't Stop!** Instead, use handles

To reference resources

- from within a handle

To represent positions

- Be careful

To pass large amounts of data(into a function)

- E.g. pass by **const** reference

To return large amount of data(out of a function)

- Don't! Instead use move operations
### How to get a lot of data cheaply out of a function?
Consider

- factory functions
- functions returning lots of objects

Return a pointer to a **new**'d object?

- M* operator+(const M&, const M&);
- M* pm = m1 + m2;  //ugly: and who does the delete?
- M* q = *pm + m3;  //ugly: and who does the delete?

Return a reference to a **new**'d object?

- M& operator+(const M&, const M&);
- M m = m1 + m2; //looks OK; but who does the delete? delete what?

Pass a target object?

- void operator+(const M&, const M&, M& result);
- M m;
- operator+(m1, m2, m); //ugly: We are regressing(退化,回归) towards assembly code(汇编代码)

**conslusion**
- **Consider**
factory functions
functions returning lots of objects(in containers)
- **Return an object!**
`M operator+(const M&, const M&);`
How? Becase copies are expensive
Tricks to avoid copying are brittle
Tricks to avoid copying are not general
- **Return a handle**
sample and cheap
#### Move semantics
- Direct support in C++11:Move constructor
  ```cpp
  class  Matrix{
    Representation rep;
    //...
    Matrix(Matrix&& a) //move constructor
    {
      rep = a.rep; //*this gets a's elements
      a.rep = {};  //a becomes the empty Matrix
    }
  };
  Matrix res = a + b;
  ```
- Often, you can avoid writing copy and move operations
Easily avoid
  ```cpp
  class Matrix{
    vector<double> elem; //elements here
    //...matrix access...
  };
  ```
- Matrix just "inherit" resource management from vector
- Copy and a move operations can often be implicitly generated from members
Good copy and move operations, e.g from the standard library
