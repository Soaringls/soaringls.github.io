# Python Basic Note

## 基本数据类型
>`int,float,str,bool,list,tuple,dict`

```py
isinstance( 3,                 int)#True
isinstance( 3.0,             float)#True
isinstance( '2==3',            str)#True
isinstance( '',                str)#True
isinstance( None == None,     bool)#True
isinstance( [1,2,'a'],        list)#True
isinstance( (1,2,'a'),       tuple)#True
isinstance( {'a':89,'b':100}, dict)#True

class Point:
    """
    """
    x = 0
pt = Point()
isinstance( pt, Point) #True 内置函数isinstance可识别自定义类型
```

返回`bool`的情况:

1. 使用关系运算符(条件运算符):<、>、<=、>=、==、！= 
2. 使用`in`和`not in`运算符
3. 使用返回`bool`的函数
4. 使用逻辑运算符`与或非:and or not`

**基本运算**
```py
a += 5 #支持复合运算符:
a = 3 + 4 #a = 7
a = 3 + \
    4     #a = 7

a++ #不支持: 只能a+=1
```

## chapter 5 条件和递归


```py
## (condition and recursion) 

a = 2 ** 3 #2的3次方
a = 105/60 #result:1.75,  python2的话进行地板除，结果为1， 105.0/60才为1.75
a = 105 // 60#result:1    "//"(地板除) is floor division operator,keep the int part of result
a = 105 % 60 #求余运算(modules operator)  result:45

#py##布尔运算(boolean expression)
5==5 #result:True
5==6 #result:False
#py##关系运算符(realtional operator)
x != y
x >  y
x >= y
x <= y
...
#py##逻辑运算符(logical operators): and or not
not (3 < 5) #result: False
#py##条件语句(conditional statements): if boolean's condition:
if x < 0:
    pass #todo, it can be operated normally
if x % 2 == 0:
    print("x is even")
elif: x < 0:
    print("x is less than zero")
else:
    print("x is odd")
#py##递归(recursive,recursion)
def countdown(n):
    if n <= 0:
        print("asdf") #base case,end condition
    else:
        print(n)
        countdown(n-1)
def print_n(s, n):
    if n <= 0:        #base case
        return
    print(s)
    print_n(s, n-1)
#py##键盘输入: python3 'input()'   python2 'raw_input()',以字符串形式返回用户键入的内容
text = input() #暂停程序执行(不提示信息),等待user输入(输入遇到换行符结束), 输入33.3,则text为"33.3", 然后继续执行
text = input("input your id:") #暂停程序执行(提示信息)
```

## chapter 6 有返回值函数

### 函数示例
```py
import math
def area(radius):
    radius = abs(radius) #radius为负时取反
    return math.pi * radius * 2
result = area(5)

## 增量式开发(incremental development):
### 每次只增加和测试少量代码，来避免长时间的调试
def distance(x1, y1, x2, y2):
    dsquared = (x1 - x2) ** 2 + (y1 - y2) ** 2
    # print("debug dsquared:",dsquared) #脚手架代码(scaffolding),调试ok后应删除
    return math.sqrt(dsquared)

##布尔函数(booleans returned func)
def is_divisible(x, y):
    if x % y == 0:
        return True
    else:
        return False
if is_divisible(4, 2):
    print("x is divisible by y")
else:
    print("x isn't divisible by y")
```

### 递归函数示例
斐波那契数列(fibonacci)

- questin:

```
fibonacci(0) = 0
fibonacci(1) = 1
fibonacci(n) = fibonacci(n - 1) + fibonacci(n - 2)
```

- solution:

```py
def fibonacci(n):
    #guardian 1
    if not isinstance(n, int): #使用内建函数isinstance确认参数类型
        print("func is only defined for integers.")
        return None
    #guardian 2
    elif n < 0:
        print("func is not defined for negative integers.")
        return None
    #run normally
    elif n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return fibonacci(n - 1) + fibonacci(n - 2)
```

## chapter 7 迭代

```py
#py##while
def countdown(n):
    while n > 0:
        print(n)
        if n == 5:
            break
        n = n - 1 #n--将语法错误, python不支持自增自减
    print("Blastoff!")

#py##for
def print_n(n):
    for i in range(n):#traverse: 0 -> n-1
        print(i)
```

## chapter 8 字符串

### `str`性质如下:

1. `[]`下标访问:  `使用str[index]`访问字符,**但不能通过下标改变字符**
2. `find`获取索引:即`find('single_char')`返回索引,找不到则返回`-1`
3. 单引号和双引号意义一样
4. 字符串之间拼接用`+`即可
5. 可用`str * int`,如`a='he ' * 3 #'he he he '`
6. 支持`in`和`not in`运算符判断单个字符或子字符串是否在某字符串中
7. 不支持`str`关键字初始化,如使用`s1 = str()`非法

### 数值转换为字符串

  ```py
  str(<numbre>) 和 %g(代替%d和%f)更通用
  #str
  res = str(43)         #'43'
  #%: 数值 %d %f %g  str:%s
  res = '%d' % 43       #'43'
  res = '%.3d' % 43     #'043' 以3位数的形式打印一个数字
  res = '%d' % (43,)    #'43'
  res = '%d' % 43.0     #'43'
  res = '%f' % 43.0     #'43.000000'
  res = '%f' % 43.123456   #'43.123456'
  res = '%10f' % 43.123456  #' 43.123456'    总长10位，(如果不够则前面补空) (如果超过则保留所有整数部分(即是整数有20位)，小数点后最多保留6位)
  res = '%.10f' % 43.123456 #'43.1234560000' 小数点后10位
  res = 'I have %d apples.' % 2  #'I have 2 apples.'
  res = 'a:%d,b:%d is fine' % (1,2) #'a:1,b:2 is fine'
  res = 'are you %s , hi %s, OK' % ('dex', 'shuai') # 'are you dex , hi shuai, OK'
  ```

### 遍历和拼接

   ```py
   a = "asdf"    #字符串为字符组成的序列,可用 [] 访问单个字符,index从0开始
   result = a[1] #result: 's'
   index = a.find('s')#返回's'43,, 1
   length =len(a)#length: 4 内建函数获取字符串长度,即字符串中字符个数
   last_char=a[len(a) - 1] #访问最后一个字符
   
   index = 0            #traverse 字符串 by while loop
   while index < len(a):
       single_char = a[index]
       print(single_char)
       index = index + 1
   for single_char in a:#traverse 字符串 by for loop
       output = single_char + ' is ok'
       print(output)
   ```

### 字符串切片
- `s[i : j]`为索引`i`到`j-1`的子串, 若`i>=j`,则结果为长度0的空字符串
- `s[ : j]`为索引`0`到`j-1`的子串
- `s[i : ]`为索引`i`到`s`结尾的子串
- `s[ : ]`为首到尾的全部
  
  ```py
  s = 'Monty Python'
  result = s[0 : 5] #result:"Monty"
  s = "asdf jkl"
  result = s[:3]
  ```

### 字符串内字符不可改变(immutable)
  
  ```py
  greeting = "hello susha"
  greeting[0] = 'H' #报错
  new_str = 'H' + greeting[1 : ] #只能创建新的
  ```

### 字符串方法

| 方法名                                      | 功能                                                                                         |
| ------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `str.find(sub_str, start_index, end_index)` | 返回sub_str首字符在str中的索引,start_index默认为0,若设置end_index，则搜索范围不包含end_index |
| `str.capitalize()`                          | 将str首字母转换为大写并返回,**未改变原字符串**                                               |
| `str.upper()`                               | 将str全部转换为大写并返回,**未改变原字符串**                                                 |
| `str.lower()`                               | 将str全部转换为小写并返回,**未改变原字符串**                                                 |
| `str.isupper()`                             | 检查str全部字符是否为大写,是返回True                                                         |
| `str.islower()`                             | 检查str全部字符是否为小写,是返回True                                                         |
| `str.strip()`                               | 删除字符串首尾空格(中间有空格不处理)并返回,**未改变原字符串**                                |
| `str.split(delimiter)`                      | 将字符串根据delimiter(default`' '`)转换为列表并返回,**未改变原字符串**                       |

   

### `in`和`not in`运算符

>`sub_str in str`:sub_str出现在str中,则返回True,否则为False

>`sub_str not in str`:sub_str不出现在str中,则返回True,否则为False

### 字符串比较
>`str1 == str2`:相等则返回True,比较之前可统一大小写
  
## chapter 9 列表(list)

>字符串是由**字符**组成的序列,而列表是**同一或不同类型**的元素(element或item)组成的序列

### `list`性质:

1. 可用`[index]`访问元素,**可通过下标改变元素**
2. 可用`for`遍历: `for elem in sample_list: ...`
3. 可用`in`和`not in`运算符
4. 可用`+`运算符拼接多个列表
5. 可用`list * int`,如`a=[0] * 3 #[0,0,0]`
6. 不支持`list`关键字初始化,如使用`l1 = list()`非法
  ```py
  empty_list = [] #空列表
  simple_list= [1, 2, 3, 4] #简单列表
  nested_list = [1, 4.3, 'dexter', [10, 20]] #(嵌套nested列表)
  print("different list:", empty_list, simple_list, nested_list)
  ```

7. 列表元素可被改变(update element)
  ```py
  test = [1, 2, 3]
  test[1] = 44 #test成为[1, 44, 3]
  ```
8. 列表操作
  ```py
  # +运算符拼接多个列表,返回新列表
  a = [1, 2, 3]
  b = [4, 5, 6]
  c = a + b #c为 [1, 2, 3, 4, 5, 6]
  # *运算符以给定次数的重复一个列表,返回新列表
  a=[0] * 3 #[0,0,0]
  ```
9. 列表切片 slice:同字符串切片,返回新列表
 
10. 列表和字符串互相转换
  ```py
  #str->list
  str = 'sp ok '
  str_list = list(str)  #['s', 'p', ' ', 'o', 'k', ' ']
  str_list = str.split()#['sp', 'ok']
  
  str = ' spam1-spam2-spam3 '
  delimiter = '-'
  str_list = str.split(delimiter) #[' spam1', 'spam2', 'spam3 '],指定分隔符'-`

  #list->str
  str = delimiter.join(str_list)
  ```
11. 对象和值:列表不同于数值和字符串
>创建相同的数值或字符串变量仅生成一个对象，而相同的列表变量则为不同的对象
  ```py
  a = 4
  b = 4
  a is b #返回True
  a = 1  #b=4
  a is b #返回False

  a = 'hello'
  b = 'hello'
  a is b #返回True
  c = a  #字符串为不可变对象,可使用别名
  c is a #返回True

  #避免对于可变对象使用别名相对更安全
  a = [1,2]
  b = [1,2]
  a is b #返回False
  c = a  #c为a的别名or引用,通过c和a都可改变对应的对象
  c is b #返回True, 
  ```

12. 列表参数
>将一个列表作为参数传给一个函数，函数将得到这个列表的一个引用，函数对这个列表进行了修改，会在调用者中有所体现
  ```py
  def delete_head(t):
    del t[0]
  
  letters = ['a', 'b', 'c']
  delete_head(letters) #letters所指对象在main以及delete_head函数内共享
  #letters 已为 ['b', 'c']
  ```

### 列表方法
>(大部分的列表方法都是无返回值的,**会改变列表**)

   | 方法名                     | 功能                                                        |
   | -------------------------- | ----------------------------------------------------------- |
   | `list.append(elem)`        | 在列表末尾添加元素,返回None                                 |
   | `list.extend(list2)`       | 在列表末尾添加另一个列表,类似`+运算符拼接多个列表`,返回None |
   | `list.sort()`              | 对列表元素进行排序,改变列表内元素顺序,返回None              |
   | `list.pop()`               | 移除列表末尾元素,并返回被删元素**str                        | dict | tuple没有pop方法** |
   | `list.pop(index)`          | 移除指定索引的元素并**返回被删元素**                        |
   | `list.remove(elem)`        | 移除指定元素(不知道index时),**会改变列表**,返回None         |
   | `list.clear()`             | 清空列表                                                    |
   | `list.count(elem)`         | 返回指定元素在列表中出现的次数                              |
   | `list.index(elem)`         | 返回指定元素在列表中的索引                                  |
   | `list.reverse()`           | 反转列表                                                    |
   | `list.copy()`              | 返回列表的浅拷贝                                            |
   | `list.insert(index, elem)` | 在指定索引位置插入元素,返回None                             |
   | `del list[index]`          | 删除指定index的元素，**会改变列表**                         |
   | `sum(list)`                | 对列表list内元素求和                                        |
   | `min(list\|tuple\|dict)`   | 返回列表或元组或字典中最小值                                |
   | `max(list\|tuple\|dict)`   | 返回列表或元组或字典中最大值                                |

## chapter 10 字典(dictionary)-即映射

### `dict`性质:
1. 元素element或项item为**键值对（key-value pair)**,key不可重复, value也可以为列表
2. 字典内元素顺序不可预测,字典的元素不使用整数索引来索引，而是用键来查找对应的值
3. 字典通过`[]`结合**key**可为元组tuple
4. 支持`dict`关键字初始化,如使用`d1 = dict()`
5. 可用`in`和`not in`运算符判断字典内是否包含某`key`
6. 不支持`+`和`*`拼接字典

### 创建及初始化
  ```py
  dict_test1 = dict() #创建空字典 {}
  dict_test2 = {}     #创建空字典 {}
  dict_test2['one'] = 'dexter' #dict_test2中添加元素

  dict_test3 = {'one': 'uno', 'two': 'dos', 'three': 'tres'}#创建非空字典
  value = dict_test3['one'] #根据key访问value
  num = len(dict_test3)     #获取元素个数
  
  #字典中是否存在某个键, 存在->True,否则False
  #字典原理为哈希表（hashtable）算法,无论字典中有多少项，in 运算符搜索所需的时间都一样
  is_item = 'one' in dict_test3

  #通过dict和zip结合创建字典
  d = dict(zip('abc', range(4))) #{'a': 0, 'b': 1, 'c': 2}
  d = dict(zip('abcd', range(3)))#{'a': 0, 'b': 1, 'c': 2}
  d['dexter','lyu'] = 1214 #tuple元组作为键,等同于 d[('dexter','lyu')] = 1214
  ```
### 字典方法
>`items()`返回由多个元组组成的序列,其中每个元组是一个键值对
  ```py
  d = {'a':0, 'b':1, 'c':2}
  t = d.items() #dict_items object ([('c', 2), ('a', 0), ('b', 1)])
  #遍历字典-转换为tuple后遍历tuple
  for k, v in d.tiems():
      print(k, v) #同时打印key-value
  #遍历字典-直接遍历
  for k in d:
      print(k, d[k])
  # 如果要以确定的顺序遍历字典，你可以使用内建方法 sorted
  def print_dict_sorted(d):
      for key in sorted(d):
          print(key, d[key])
  ```
### 字典作为计数器集合
  ```py
  def histogram(str):
      d = {}
      for c in str:
          if c not in d:
              d[c] = 1
          else:
              d[c] += 1
      return d
  h = histogram("a")  #假设 h = {'a': 2}
  num = h.get('a')    #返回2,若字典h内没有关键字为'a',返回None
  num = h.get('a', 0) #返回2   get(key, default_value)
  num = h.get('a', 11)#返回2  h内没有key为'a'的键,返回实际的value
  num = h.get('b', 11)#返回11,h内没有key为'b'的键,返回default_value
  ```
### 逆向查找(通过value 找 key)
  >查找速度比通过key->value慢很多
  ```py
  #接受一个值并返回映射到该值的第一个键
  def reverse_lookup(d, v):
      for k in d:
          if d[k] == v:
              return k
      raise LookupError('value does not appear in the dictionary') #raise语句触发异常,表示查询失败
  ```
### 倒转字典
  ```py
  def invert_dict(d):
      d_inverse = dict() #同d_inverse = {}
      for key in d:
          val = d[key]
          if val no in d_inverse:
              d_inverse[val] = [key]
          else:
              d_inverse[val].append(key)
      return d_inverse
  ```
### 示例:备忘录
斐波那契数列(fibonacci)

- `questin:`
  ```
  fibonacci(0) = 0
  fibonacci(1) = 1
  fibonacci(n) = fibonacci(n - 1) + fibonacci(n - 2)
  ```

- `solution:` 
  ```py
  konw = {0:0, 1:1}
  def fibonacci(n):
      if n in know:
          return know[n]
      res = fibonacci(n - 1) + fibonacci(n - 2)
      know[n] = res
      return res
  ```

## chapter 11 元组(tuple)
>与列表相似,元素类型也可不一样,但元素不可改变
### 基本性质 
1. 列表大多操作适用于元组,如下标`[]`访问、切片、**不可通过下标改变元素**通过`[]`修改元素将报错
2. 和列表类似,完全相同的两个元组t1和t2, `t1 is t2`为`False`. `t1 = t2`后`t1 is t2`才为`True`.**使用别名安全**,因为元素不可改
3. 关系运算符适用(从第一个元素开始比较)`(0, 1, 2) < (0, 3, 4)`->`True`,而`(0, 1, 2000000) < (0, 3, 4)`->`False`
4. 支持`tupe`关键字初始化,如使用`t1 = tuple()`
5. 支持`t1+t2`,返回拼接后tuple,  但t1和2元素个数和类型须相同
6. 支持`t1*3`,返回拼接后tuple
7. 支持`in`和`not in`运算符

### 创建及初始化
  ```py
  t = tuple() #创建空的tuple
  t = ()      #创建空的tuple
  t = 'a', 'b', 'c', 'd', 'e'
  t = ('a', 'b', 'c', 'd', 'e')

  t2 = 'a',   #t2为一个元素的tuple
  t2 = ('a',) #t2为一个元素的tuple
  t2 = 'a'    #t2为字符 'a'
  t2 = ('a')  #t2为字符 'a'
  ```

### 元组赋值
  ```py
  #交换-1
  tmp = a
  a = b
  b = tmp
  
  #交换-2
  a,b = b,a
  #赋值,一下不用方式赋值结果都一致,a = 1,b=2,c=3
  a,b,c = 1,2,3   #等号两边数目须相同
  a,b,c = [1,2,3] #list assignment
  a,b,c = (1,2,3) #tuple assignment
  a,b,c = {1:'a',2:'b',3:'c'} #dict assignment

  #also list assignment
  addr = 'monty@python.org'
  uname, domain = addr.split('@') #uname:monty  domain:python.org
  ```

### 元组作为返回值
  ```py
  res = divmod(7, 3) #res=(2, 1) 分别为商和余数
  result, mod = res  #result:2  mod:1

  #返回元组的函数
  def min_max(t):
      return min(t), max(t)
  res = min_max([0,1,2,-5]) #res=(-5, 2)
  ```

### 可变长度参数元组
  ```py
  #函数可以接受可变数量的参数。 以 “*” 开头的形参将输入的参数 汇集 到一个元组中
  def printall(*args):
      print(args)
  printall(1, 2.0, '3')

  t = (7, 3)
  res = divmod(t) #TypeError: divmod expected 2 arguments, got 1
  res = divmod(*t)#ok, 将这个元组分散，它就可以被传递进函数
  res = max(t)    #ok,
  res = min(t)    #ok,
  res = sum(t)    #ok,
  res = sum((7,3))  #ok
  res = sum(7,3)  #error
  ```

### 元组和列表
  ```py
  s = 'abc'
  t = [0,1,2]
  zip_obj = zip(s, t) #返回zip对象 ('a', 0) ('b', 1) ('c', 2)

  #[('a', 0), ('b', 1), ('c', 2)]
  zip_list = list(zip_obj) #zip_obj将为空，内容被窃取

  #zip对象使用for遍历
  for pair in zip(s, t):
      print(pair)

  #enumerate的返回结果是一个枚举对象（enumerate object）
  for idx, elem in enumerate('abc'):#分别输出下标及对应的每个字符
      print(idx, elem)
  ```
### 元组和字典
>参见第十章字典部分

## Appendix: tips
- 全局变量`global`
>函数外申明的都为全局变量，申明之后的地方才能使用，函数内同名变量将替换函数外的全局变量，函数内修改全局变量需用global关键字
  ```py
  var1 = 1 #函数外全局变量
  
  def func1():
    var1 = 2 #函数内局部变量，不会修改函数外的同名变量
  
  def func2():
    global var1
    var1 = 2 #修改函数外的var1
  ```

- 局部变量
>函数内的都是局部变量，for内定义的临时变量在for外也是可用的，但出了函数就不可用
  ```py
  def func():
    local_var = 1
    for i range(5):
      tmp_var = 2 #作用域不仅是for内，for外后面也可以，和C++的重大区别！！！！
    
    #local_var和tmp_var都为当前函数`func`内局部变量，申明后都可用
    sum_var = local_var + tmp_var 
  ```

- 列表list的clear和`=[]`
  ```py
  list1 = [1,2,3]
  list2 = [4,5,6]
  data = []
  data.append(list1) 
  data.append(list2) 
  
  list1.clear() #将会导致共同引用的data内的数据也清空
  list2 = []    #创建了一个新的空列表对象并将list2引用新的对象
  ```