# C++ New Feture


## c++ new features and usage

### keywords

- nodiscard
  ```cpp
  //from c++17 如果返回值没有被赋予到某个变量，编译将会wanrning
  [[nodiscard]] bool IsChina(); 
  ```
- maybe_unused
  ```cpp
  //from c++17 可能不用的变量
  [[maybe_unused]] std::string name;
  ```
- constexpr and const
  ```cpp
  //constexpr since c++11
  const double PI1 = 3.1415926;     //initialized at compile time or run time
  constexpr double PI2 = 3.1415926; //initialized at compile time, compile-time constant

  constexpr double PI3 = PI1; //error
  constexpr double PI3 = PI2; //ok

  //const initialized at run time
  int num;
  num = ....;
  const int kArraySize = num;
  ```

### 基本函数

| `math函数`                               | `描述`                                                                                     |
| :--------------------------------------- | :----------------------------------------------------------------------------------------- |
| std::atan2(y,x) <br />即tan(angle) = y/x | ngle范围[-PI, PI] [-180°, 180°]                                                            |
| std::atan(x)    <br />即tan(angle) = x   | angle范围[-PI/2, PI/2]  [-90°, 90°]                                                        |
| atof()                                   | double atof(const char *str) string转double                                                |
| std::to_string()                         | 数值转string，浮点数转string时 `std::to_string(12.12) = "12.120000"`                       |
| std::stod("124.123")                     | 将字符串"124.123"转成double类型                                                            |
| std::stoi("123")                         | 将字符串"123"转成int类型                                                                   |
| std::min(a,b)                            | 返回a,b中较小的, **a、b类型必须一致**                                                      |
| std::max(a,b)                            | 返回a,b中较大的, **a、b类型必须一致**                                                      |
| std::fmod(x, y)                          | 计算x/y的浮点余数，如std::fmod(3.1, 2.0) = 1.1  <br />**%只用于整型的求余后一个数不能为0** |
| std::hypot(x, y)                         | 等同于 std::sqrt(x*x + y*y),  如 std::hypot(3,4) = 5                                       |
| std::floor(param)                        | 向下取整:不大于给定值的最近整数   4.5/4.2/4.8结果都为4.0(返回还是浮点数,不是int)           |
| std::ceil(param)                         | 向上取整:不小于给定值的最近整数    4.5/4.2/4.8结果都为5.0                                  |
| std::round(param)                        | 就近取整:即4舍5入取整    4.45为4  4.5/4.55为5.0                                            |
| std::isfinite(param)                     | 若为正常有限数字,在-Infinity和Infinity之间返回true,infinity则返回false                     |
| std::isnan(pt.x)                         | 判断点pt的x值是否为`nan值`                                                                 |
| **`boost相关`**                          | **`描述`**                                                                                 |
| boost::lexical_cast                      | 用于类型转换，使用的stringstream实现的数值类型转换                                         |


### 常见用法(std::optional etc)

- std::adjacent_find

```cpp
TODO

```

- std::set_intersection

```cpp
std::set<int> set_a(a.begin(), a.end());
std::set<int> set_b(b.begin(), b.end());
std::vector<int> common_a_b;
std::set_intersection(set_a.cbegin(), set_a.cend(), 
                      set_b.cbegin(), set_b.cend(), std::back_inserter(common_a_b));
```

- std::optional

```cpp
std::optional<std::string>  GetInfo(){
  //func1
  std::string result_1; 
  ...
  if(result_1.empty) return std::nullopt;
  else return result_1;
  
  //func2
  std::optional<std::string> result_2 = std::nullopt;
  ...
  result_2 = "hello world";
  ...
  return result_2;
} 
ret = GetInfo();
CHECK(ret.has_value())<<"Failed to parser...";
const std::string info = ret.value();
```

- `std::unique()`
> 作用：去除容器中重复的元素，结合sort和unique使用，可以实现排序去重

```cpp
// remove duplicate elements
std::vector<int> v{123,432,1,2,3,1,2,3,3,4,5,4,5,6,7};

//默认升序,即std::sort(v.begin(), v.end(),std::less<int>());降序则std::greater<int>()
std::sort(v.begin(), v.end()); 
auto last = std::unique(v.begin(), v.end());//v必须是有序数组(升序/降序均可)
// now the v: {1 2 3 4 5 6 7 123 432 5 5 6 7 123 432}
const index_last = std::distance(v.begin(), last);
v.erase(last, v.end()); //now v: {1 2 3 4 5 6 7 123 432} 
```


- `std::upper_bound`、`std::lower_bound`、  ` std::distance`

```cpp
std::upper_bound: 左小右大原则， ref < 结果, lambda内比较与参数一致，参数ref第一个
int next_gt = std::distance(vec.begin(), 
                         std::upper_bound(vec.begin(), vec.end(), timestamp_ref,
                                         [](double target, const auto& elem){
                                           return target < elem;
                                        });
std::lower_bound: 左小右大原则， ref <= 结果,lambda内比较与参数一致,参数ref第二个
int next_ge = std::distance(vec.begin(),
                           std::lower_bound(vec.begin(), vec.end(), time_ref, 
                                           [](const auto& elem, double target){
                                             return elem < target;
                                           }));
```

- `std::accumulate`和 `std::min_element`、`std::max_element`

```cpp
std::vector<float> values;
const flost min = *std::min_element(values.begin(),values.end());
//std::min std::max 要求数据类型一致

/**
 * 获取除指定值之外的最值
*/
std::vectro<double> arr_vec;
.... //假设arr_vec内包含极大值 FLT_MAX 和极小值FLT_MIN 需要排除
const double min_value = std::max_element(arr_vec.begin(),arr_vec.end(),
                                     [(const auto& ele1, const auto& ele2){
                                      if(ele1 == FLT_MAX || ele2 == FLT_MAX){
                                        return true;
                                      }
                                      return ele1 < ele2;//
                                     }]);
const double min_value = std::max_element(arr_vec.begin(),arr_vec.end(),
                                     [(const auto& ele1, const auto& ele2){
                                      if(ele1 == FLT_MIN || ele2 == FLT_MIN){
                                        return false;
                                      }
                                      return ele1 < ele2;
                                     }]); 
auto max_size = std::max_element(
      lines.begin(), lines.end(), [](const auto& lhs, const auto& rhs) {
        return lhs.points.size() < rhs.points.size();// lhs... > rhs... 则找到的最小的元素
      });
auto min_size = std::min_element(
      lines.begin(), lines.end(), [](const auto& lhs, const auto& rhs) {
        return lhs.points.size() < rhs.points.size();// lhs... > rhs... 则找到的最大的元素
      });
std::cout << "max elemnt:" << max_size->id << std::endl;
std::cout << "min elemnt:" << min_size->id << std::endl;
```

- std::none_of和std::any_of

```cpp
if (std::none_of(level_to_polygons[level].begin(),
                 level_to_polygons[level].end(),
                 [&](const auto& polygon) {
                  //取反
                  return !polygon.IsPointIn(
                                     {smooth_point.x(), smooth_point.y()});
   })) {
  return true;//filtered
}
//is same as below
if(std::any_of(level_to_polygons[level].begin(),
               level_to_polygons[level].end(),
               [&](const auto& polygon) {
                 return polygon.IsPointIn(
                                     {smooth_point.x(), smooth_point.y()});
})){
    return true;//filtered
}
```

- `std::transfrom`

```cpp
void StringToLower(std::string* str){
  std::transfrom(str->begin(), str->end(), std::tolower);
}
```

- `std::remove_if、std::regex_search`

```cpp
std::vector<std::string> file_names = {.....};
file_names.erase(
          //通过std::remove_if获取file_names内要erase的元素列表 X
          std::remove_if(file_names.begin(), file_names.end(),
                         [&](const std::string& frame_filename) {
                           //patch_ids为要保留的文件
                           for (const auto& id : patch_ids) {
                             if (std::regex_search(
                                     frame_filename,
                                     std::regex(absl::StrCat(id, ".pb.bin")))) {
                               return false;//不加入列表 X
                             }
                           }
                           return true;//加入列表 X
                         }),
          file_names.end());
```

- std::typeid

可用作关联与无序关联容器的索引

```cpp
#include <iostream>
#include <typeinfo>
#include <typeindex>
#include <unordered_map>
#include <string>
#include <memory>
 
struct A {
    virtual ~A() {}
};
 
struct B : A {};
struct C : A {};
 
int main()
{
    std::unordered_map<std::type_index, std::string> type_names;
 
    type_names[std::type_index(typeid(int))] = "int";
    type_names[std::type_index(typeid(double))] = "double";
    type_names[std::type_index(typeid(A))] = "A";
    type_names[std::type_index(typeid(B))] = "B";
    type_names[std::type_index(typeid(C))] = "C";
 
    int i;
    double d;
    A a;
 
    // 注意我们正在存储指向类型 A 的指针
    std::unique_ptr<A> b(new B);
    std::unique_ptr<A> c(new C);
 
    std::cout << "i is " << type_names[std::type_index(typeid(i))] << '\n';
    std::cout << "d is " << type_names[std::type_index(typeid(d))] << '\n';
    std::cout << "a is " << type_names[std::type_index(typeid(a))] << '\n';
    std::cout << "b is " << type_names[std::type_index(typeid(*b))] << '\n';
    std::cout << "c is " << type_names[std::type_index(typeid(*c))] << '\n';
}

////output is below
i is int
d is double
a is A
b is B
c is C
```

- vector.erase

```cpp
std::vector<int> vecs = {};
//正确做法
for(auto iter = vecs.begin(); iter != vecs.end();){
  if(/*erase-condition*/){
    iter = vecs.erase(iter);
  }else{
    iter++;
  }
}
//错误做法
for(auto iter = vecs.begin(); iter != vecs.end(); iter++){
  if(/*erase-condition*/){
    iter = vecs.erase(iter);
  }
}
```


- `usage:"std::forward_as_tuple`

```cpp
struct NodeId {
  NodeId(int trajectory_id, int node_index)
    : trajectory_id(trajectory_id), node_index(node_index) {}
  
  int trajectory_id;
  int node_index;
  bool operator<(const NodeId& other) const {
   return std::forward_as_tuple(trajectory_id, node_index) <
   std::forward_as_tuple(other.trajectory_id, other.node_index);
}

std::map<int, NodeId> extrapolators_;
extrapolators_.emplace(std::piecewise_construct, std::forward_as_tuple(5), std::forward_as_tuple(2, 3));
```

## C++17 新特性
### 构造函数模板推导
Automatic template argument deduction much like how it's done for functions, but now including class constructors.
```cpp
//eg.1
template<typename T = float>
struct MyContainer{
    T val_;
    MyContainer():val_{}{}
    MyContainer(T val):val_(val){}
    //...
};
MyContainer c1{1};// type->int
MyContainer c2;   // type->float,default

//eg.2
std::pair<int, double> p(1, 2.2); //before 17
std::pair p(1, 2.2); //now, 自动推导
std::vector v = {1, 2, 3};//now
```
### Declaring non-type template parameters with auto
Following the deduction rules of `auto`, while respecting the non-type template parameter list of allowable types[\*], template arguments can be deduced from the type ot its arguments:
```cpp
template <auto... seq>
struct my_integer_sequence {
  // Implementation here ...
};

// Explicitly pass type `int` as template argument.
auto seq = std::integer_sequence<int, 0, 1, 2>();
// Type is deduced to be `int`.
auto seq2 = my_integer_sequence<0, 1, 2>();
```

### Folding expressions
A fold expression performs a fold of a template parameter pack over a binary operator.

- An expression of the form `(... op e)` or `(e op ...)`, where `op` is a fold-operator and `e` is an unexpanded parameter pack, are called unary folds.
- An expression of the form `(e1 op ... op e2)`, where `op` are fold-operators, is called a binary fold. Either `e1` or `e2` is an unexpanded parameter pack, but not both.

```cpp
template <typename... Args>
bool logicalAnd(Args... args) {
    // Binary folding.
    return (true && ... && args);
}
bool b = true;
bool& b2 = b;
logicalAnd(b, b2, true); // == true

template <typename... Args>
auto sum(Args... args) {
    // Unary folding.
    return (... + args);
}
sum(1.0, 2.0f, 3); // == 6.0
```

### New rules for auto deduction from braced-init-list
Changes to `auto` deduction when used with the uniform initialization syntax. Previously, `auto x {3}` deduced a `std::initializer_list<int>`, which now deduces to `int`.
```cpp
auto x1 {1, 2, 3};  // error: not a single element.
auto x2 = {1, 2, 3};  // x2 is std::initializer_list<int>
auto x3 {3};  // x3 is int
auto x4 {3.0};  // x4 is double
```

### constexpr lambda
Compile-time lambda using `constexpr`.
```cpp
auto identity = [](int n) constexpr { return n; };
static_assert(identity(123) == 123);
constexpr auto add = [](int x, int y) {
  auto L = [=] { return x; };
  auto R = [=] { return y; };
  return [=] { return L() + R(); };
};

static_assert(add(1, 2)() == 3);
constexpr int addOne(int n) {
  return [n] { return n + 1; }();
}

static_assert(addOne(1) == 2);
```

### Lambda capture `this` by value
Capturing `this` in a lambda's environment was previously reference-only. An example of where `this` is problematic is asynchronous code using callbacks that require an object to be available, potentially past its lifetime. `*this` (C++17) will now make a copy of the current object, while `this` (C++11) continues to capture by reference.
```cpp
struct MyObj {
  int value {123};
  auto getValueCopy() {
    return [*this] { return value; };
  }
  auto getValueRef() {
    return [this] { return value; };
  }
};
MyObj mo;
auto valueCopy = mo.getValueCopy();
auto valueRef = mo.getValueRef();
mo.value = 321;
valueCopy(); // 123
valueRef(); // 321
```

### Inline variables
The inline specifier can be applied to variables as well as to functions. A variable declared inline has the same semantics as a function declared inline.
```cpp
// Disassembly example using compiler explorer.
struct S { int x; };
inline S x1 = S{321}; // mov esi, dword ptr [x1]
                      // x1: .long 321

S x2 = S{123};        // mov eax, dword ptr [.L_ZZ4mainE2x2]
                      // mov dword ptr [rbp - 8], eax
                      // .L_ZZ4mainE2x2: .long 123
```
It can also be used to declare and define a static member variable, such that it does not need to be initialized in the source file.
```cpp
struct S {
  S() : id{count++} {}
  ~S() { count--; }
  int id;
  static inline int count{0}; // declare and initialize count to 0 within the class
};
```

### Nested namespaces
Using the namespace resolution operator to create nested namespace definitions.
```cpp
namespace A {
  namespace B {
    namespace C {
      int i;
    }
  }
}
// vs.
namespace A::B::C {
  int i;
}
```

### Structured bindings
A proposal for de-structuring initialization, that would allow writting `auto [ x, y, z] = expr;` where the type of `expr` was a tuple-like object, whose elements would be bound to the variables `x`, `y` and `z`(which is construc declares). **tuple-like** objects include `std::tuple`, `std::pair`, `std::array`, and aggregate structures.
```cpp
using Coordinate = std::pair<int, int>;
Coordinate origin() {
  return Coordinate{0, 0};
}

const auto [ x, y ] = origin();
x; // == 0
y; // == 0
std::unordered_map<std::string, int> mapping {
  {"a", 1},
  {"b", 2},
  {"c", 3}
};

// Destructure by reference.
for (const auto& [key, value] : mapping) {
  // Do something with key and value
}
```

### Selection statements with initializer
New version of `if` and `switch` statements which simplify code patterns and help users keep scopes tight.
```cpp
{
  std::lock_guard<std::mutex> lk(mx);
  if (v.empty()) v.push_back(val);
}
// vs.
if (std::lock_guard<std::mutex> lk(mx); v.empty()) {
  v.push_back(val);
}

Foo gadget(args);
switch (auto s = gadget.status()) {
  case OK: gadget.zip(); break;
  case Bad: throw BadFoo(s.message());
}
// vs.
switch (Foo gadget(args); auto s = gadget.status()) {
  case OK: gadget.zip(); break;
  case Bad: throw BadFoo(s.message());
}
```

### constexpr if
Write code that is instantiated depending on a compile=time condition.
```cpp
template <typename T>
constexpr bool isIntegral() {
  if constexpr (std::is_integral<T>::value) {
    return true;
  } else {
    return false;
  }
}
static_assert(isIntegral<int>() == true);
static_assert(isIntegral<char>() == true);
static_assert(isIntegral<double>() == false);
struct S {};
static_assert(isIntegral<S>() == false);
```

### UTF-8 character literals
A character literal that begins with `u8` is a character literal of type `char`. The value of a UTF-8 character literal is equal to its ISO 10646 code point value.
```cpp
char x = u8'x';
```

### Direct list initialization of enums
Enums can now be initialized using braced syntax.
```cpp
enum byte : unsigned char {};
byte b {0}; // OK
byte c {-1}; // ERROR
byte d = byte{1}; // OK
byte e = byte{256}; // ERROR
```

### fallthrough, nodiscard, maybe_unused attributes
C++17 introduces threee new attributes:

- `[[fallthrough]]`: indicates to the compiler that falling through in a switch statement is intended behavior.
```cpp
switch (n) {
  case 1: [[fallthrough]]
    // ...
  case 2:
    // ...
    break;
}
```

- `[[nodiscard]]`: issues a warning when either a function or class has this attribute and its return value is discarded.
```cpp
[[nodiscard]] bool do_something() {
  return is_success; // true for success, false for failure
}

do_something(); // warning: ignoring return value of 'bool do_something()',
                // declared with attribute 'nodiscard'

// Only issues a warning when `error_info` is returned by value.
struct [[nodiscard]] error_info {
  // ...
};

error_info do_something() {
  error_info ei;
  // ...
  return ei;
}

do_something(); // warning: ignoring returned value of type 'error_info',
                // declared with attribute 'nodiscard'
```

- `[[maybe_unused]]`: indicates to be compiler that a variable or parameter might be unused an is intended.
```cpp
void my_callback(std::string msg, [[maybe_unused]] bool error) {
  // Don't care if `msg` is an error message, just log it.
  log(msg);
}
```
 
### std::variant
The class template `std::variant` represents a type-safe `union`. An instance of `std::variant` at any given time holds a value of one of its alternativqe types(it's possible for it to be valueless).
```cpp
std::variant<int, double> v{ 12 };
std::get<int>(v); // == 12
std::get<0>(v); // == 12
v = 12.0;
std::get<double>(v); // == 12.0
std::get<1>(v); // == 12.0
```

### std::optional
```cpp
std::optional<std::string> create(bool b) {
  if (b) {
    return "Godzilla";
  } else {
    return {};
  }
}

create(false).value_or("empty"); // == "empty"
create(true).value(); // == "Godzilla"
// optional-returning factory functions are usable as conditions of while and if
if (auto str = create(true)) {
  // ...
}
```

### std::any
A type-safe container for single values of any type.
```cpp
std::any x {5};
x.has_value() // == true
std::any_cast<int>(x) // == 5
std::any_cast<int&>(x) = 10;
std::any_cast<int>(x) // == 10
```

### std::string_view
A non-owning reference to a string. Useful for providing an abstraction on top of strings (e.g. for parsing).
```cpp
// Regular strings.
std::string_view cppstr {"foo"};
// Wide strings.
std::wstring_view wcstr_v {L"baz"};
// Character arrays.
char array[3] = {'b', 'a', 'r'};
std::string_view array_v(array, std::size(array));

std::string str {"   trim me"};
std::string_view v {str};
v.remove_prefix(std::min(v.find_first_not_of(" "), v.size()));
str; //  == "   trim me"
v; // == "trim me"
```

### std::invoke
Invoke a `Callable` object with parameters. Examples of `Callable` objects are `std::function` or `std::bind` where an object can be called similarly to a regular function.
```cpp
template <typename Callable>
class Proxy {
  Callable c;
public:
  Proxy(Callable c): c(c) {}
  template <class... Args>
  decltype(auto) operator()(Args&&... args) {
    // ...
    return std::invoke(c, std::forward<Args>(args)...);
  }
};
auto add = [](int x, int y) {
  return x + y;
};
Proxy<decltype(add)> p {add};
p(1, 2); // == 3
```

### std::apply
Invoke a `Callable` object with a tuple of arguments
```cpp
auto add = [](int x, int y) {
  return x + y;
};
std::apply(add, std::make_tuple(1, 2)); // == 3
```

### std::filesystem
The new `std::filesystem` library provides a standard way to manipulate files, directories, and paths in a filesystem.
```cpp
const auto bigFilePath {"bigFileToCopy"};
if (std::filesystem::exists(bigFilePath)) {
  const auto bigFileSize {std::filesystem::file_size(bigFilePath)};
  std::filesystem::path tmpPath {"/tmp"};
  if (std::filesystem::space(tmpPath).available > bigFileSize) {
    std::filesystem::create_directory(tmpPath.append("example"));
    std::filesystem::copy_file(bigFilePath, tmpPath.append("newFile"));
  }
}
```

### std::byte
The new `std::byte` type provides a standard way of representing data as byte. Benefits of using `std::byte` over `char` or `unsigned char` is that it is not a character type, and is also not an arithmetic type; while the only operator overloads available are bitwise operator.
```cpp
std::byte a {0};
std::byte b {0xFF};
int i = std::to_integer<int>(b); // 0xFF
std::byte c = a & b;
int j = std::to_integer<int>(c); // 0
```

### Splicing for maps and sets
Moving nodes and merging containers whithout the overhead of expensive copies, moves, or heap allocations/deallocations.
Moving elements from one map to another:
```cpp
std::map<int, string> src {{1, "one"}, {2, "two"}, {3, "buckle my shoe"}};
std::map<int, string> dst {{3, "three"}};
dst.insert(src.extract(src.find(1))); // Cheap remove and insert of { 1, "one" } from `src` to `dst`.
dst.insert(src.extract(2)); // Cheap remove and insert of { 2, "two" } from `src` to `dst`.
// dst == { { 1, "one" }, { 2, "two" }, { 3, "three" } };
```
Inserting elements which outlive the container:
```cpp
auto elementFactory() {
  std::set<...> s;
  s.emplace(...);
  return s.extract(s.begin());
}
s2.insert(elementFactory());
```
Changing the key of a map element:
```cpp
std::map<int, string> m {{1, "one"}, {2, "two"}, {3, "three"}};
auto e = m.extract(2);
e.key() = 4;
m.insert(std::move(e));
// m == { { 1, "one" }, { 3, "three" }, { 4, "two" } }
```

### parallel algorithms
Many of the STL algorithms, such as the `copy`, `find` and `sort` methods, started to support the parallel execution policies: `seq`, `par` and `par_unseq` which translate to "sequentially", "parallel" and "parallel unsequenced".
```cpp
std::vector<int> longVector;
// Find element using parallel execution policy
auto result1 = std::find(std::execution::par, std::begin(longVector), std::end(longVector), 2);
// Sort elements using sequential execution policy
auto result2 = std::sort(std::execution::seq, std::begin(longVector), std::end(longVector));
```