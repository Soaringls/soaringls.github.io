# Python advance
## chapter 19 进阶小技巧

- 条件表达式
  ```py
  #normal way
  if x > 0:
    y = math.log(x)
  else:
    y = float('nan')
  #conditional way
  y = math.log(x) if x > 0 else float('nan')
  ```
- 列表推导式
  ```py
  #normal way
  def capitalize_all(t):
    res = []
    for s in t:
        res.append(s.capitalize())
    return res
  #new way
  def capitalize_all(t):
    return [s.capitalize() for s in t]
  ```
- 生成器表达式
 
 TODO: 补充

- **any和all**
  `any`有一个True即为True,`all`有一个False即为False
  
  ```py
  any( [False, False, True] ) #True
  any( letter == 't' for letter in 'monty' )
  ```

## chapter 21 算法分析

### 实现哈希表
  [ref实现哈希表](https://codingpy.com/books/thinkpython2/21-analysis-of-algorithms.html#python)
  ```py
  class LinearMap:
  """aotim map"""
      def __init__(self):
          self.items = []
      def add(self, k, v):
          self.items.append((k,v))
      def get(self, k):
          for key, val in self.items:
              if key == k:
                  return val
          raise KeyError
  class BetterMap:
  """预计比LinearMap快100倍,但增长量级仍是线性的,还不如哈希表好用"""
      def __init__(self, n = 100):
          self.maps = []
          for i in range(n):
              self.maps.append(Linear())
      def find_map(self, k):
          #使用内建的hash函数,可接受任何python对象(列表和字典等可变类型不能哈希的除外)并返回一个整数
          index = hash(k) % len(self.maps)
          return self.maps[index]
      def add(self, k, v):
          m = self.find_map(k)
          return m.add(k, v)
      def get(self, k):
          m = self.find_map(k)
          return m.get(k)
  class HashMap:
  """hash map"""
      def __init__(self):
          self.maps = BetterMap(2)
          self.num = 0
      def get(self, k):
          return self.maps.get(k)
      def add(self, k, v):
          #add通常是常数时间O(1),需要重新调整执行resize()时才消耗线性时间
          if self.num == len(self.maps.maps):
              self.resize()
          self.maps.add(k, v)
          self.num += 1
      def resize(self):
          new_maps = BetterMap(self.num * 2)
          for m in self.maps.maps:
              for k, v in m.items:
                  new_maps.add(k, v)

          self.maps = new_maps
  ```

## chapter 使用文件
### 读写文件
```py
mode = 'r';
#mode:'w':写入(文件没有则新建，文件存在将清空文件原有数据)
#mode:'a':写入(文件没有则新建，文件存在将追加内容)
#mode:'r':只读,不可写入(文open()件不存在将报错)
try:
    fout = open("file.txt", mode)#'w' or 'a'
except:
    print("couldn't open the file")
fout.write("hello")#返回写入的字符个数
x = 54
fout.write(str(x))#写入number前,转为字符串
fout.close()

fin = open("file.txt", mode) #open(...) 文件对象,mode默认为'r'
copen()urrent_line = fin.readline() #遇到换行符停止，即读取一行
word = current_line.strip() #删除字符串首尾空格
#py##使用for loop遍历文件对象
fopen()or line in fin:
    word = line.strip()
    print(word)
fin.close()
```
 
### 使用数据库(pickle模块)open()open()
>大多数的数据库采用类似字典的形式，即将键映射到值,不同于字典,数据库的键的类型须为`str`

- dbm
  使用dbm:键和值必须是字符串或者字节,用其它数据类型，你会得到一个错误
  ```py
  import dbm
  db = dbm.open('db_test', 'c')#mode:'c' 表示数据库不存在将创建
  db['45'] = 'hello' #写入数据库
  value = db['45']   #访问数据库 返回字节对象(同字符串类似)"b'hello'"
  
  #访问
  for key in db:
      print(key, db[key])
  db.close()
  ```

- pickle
  将几乎所有类型的对象转化为适合在数据库中存储的字符串，以及将那些字符串还原为原来的对象
  ```py
  import pickle
  t = [1,2,3,'s']
  s = pickle.dumps(t)
  t2 = pickle.loads(s) #即为t的内容
  t2 == t #True 序列化然后反序列化等效于复制一个对象
  t2 is t #False
  ```

## 正则表达式

| **字符** | **表示**                                        | **实例** |
| -------- | ----------------------------------------------- | -------- |
| \d       | 0-9的任何数字                                   |
| \D       | 0-9的以外的任何字符                             |
| \w       | 任何字母、数字、下划线,可认为匹配单词           |
| \W       | \w以外的任何字符                                |
| \s       | 空格、制表符\t、换行符\n,可认为是匹配’空白‘字符 |
| \S       | \s以外的任何字符                                |

```py
import re #re模块包含正则表达相关含函数
#匹配"asfasf123-123-1234asfasf"中的123-123-1234
reg  = re.compile(r'\d\d\d-\d\d\d-\d\d\d\d')
reg1 = re.compile(r'(\d\d\d)-(\d\d\d-\d\d\d\d)') #和reg一样,只是分为2组
reg2 = re.compile(r'\d{3}-\d{3}-\d{4}')
#------------------------------------
#title:使用管道'|'匹配多个分组
#tips :如果要匹配字符串中的'|',则需要使用倒斜杠转义,即\|
#------------------------------------
reg  = re.compile(r'Batman|Tina Fey')  #匹配第一次出现的文本
#对于'Batman and Tina Fey'的匹配，结果为'Batman'
#对于'Tina Fey and Batman'的匹配，结果为'Tina Fey'
reg1 = re.compile(r'Bat(man|mobile|bat|copter)') #匹配字符串中含有Batman、Batmobile、Batbat、Batcopter中的某一个
#------------------------------------
#title:使用'?'实现可选匹配
#tips :如果要匹配字符串中的'？',则需要使用倒斜杠转义,即\？
#------------------------------------
reg  = re.compile(r'Bat(wo)?man') #模式wo为可选的分组,wo出现0次或1次,既可匹配字符串中的Batman,也可匹配Batwoman
#------------------------------------
#title:使用'*'匹配0次或多次
#tips :如果要匹配字符串中的'*',则需要使用倒斜杠转义,即\*
#------------------------------------
reg  = re.compile(r'Bat(wo)*man') #(wo)*匹配'wo'零次或多次,可匹配Batman、Batwoman、Batwowoman...
#------------------------------------
#title:使用'+'匹配1次或多次
#tips :如*果要匹配字符串中的'+',则需要使用倒斜杠转义,即\+
#------------------------------------
reg  = re.compile(r'Bat(wo)+man') #(wo)+匹配'wo'1次或多次,可匹配Batwoman、Batwowoman...
#------------------------------------
#title:使用'{}'匹配特定次数
#tips :
#------------------------------------
reg  = re.compile(r'(Ha){3}') #'Ha'出现3次,匹配字符串中的’HaHaHa',但不会匹配'HaHa'
#{3,5} 出现3-5次   {3，}至少出现3次以上

#------------------------------------
#title:贪心(Ha){3,5}和非贪心(Ha){3,5}？匹配
#tips :
#------------------------------------
#对于包含'HaHaHaHaHa'的字符串
reg1 = re.compile(r'(Ha){3,5}')    #贪心匹配结果为HaHaHaHaHa,Ha出现5次的
reg2 = re.compile(r'(Ha){3,5}？')  #非贪心匹配结果为HaHaHa,Ha出现3次的
```

```py
#[0-5] 和 (0|1|2|3|4|5) 作用一样，匹配0-5中的一个
#[aeiouAEIOU]匹配元音字符,不论大小写  [^aeiouAEIOU] 则是匹配非元音字符
#[a-zA-Z0-9] 匹配所有的大小写字母和数字
#方括号[]内正则表达式符号一般不被解释,不需要在'.'、'?'、'()'用'\'转义
```

```py
#------------------------------------
#title:开始'^'末尾'$'
#tips :插入符号'^'
#------------------------------------
reg  = re.compile(r'^Hello') #匹配以'Hello'开始的字符串
#r'\d$' 匹配以0-9中某个数结束的字符串
#r'^\d+$' 匹配从开始到结束都是数字的字符串

#------------------------------------
#title:通配符'.'
#tips :匹配除换行之外所有字符,如果要匹配字符串中的'.',则需要使用倒斜杠转义,即\.
#------------------------------------
#r'.at' 匹配cat、lat、hat....,        '.'只能匹配一个字符  
#r'.*at' 匹配cccccat、9-098.\.at...., '.*'匹配所有字符, 如r'First Name:(.*) Last Name:(.*)'  
##对于'<To serve man> for dinner.>'
##r'<.*>'  匹配结果为'<To serve man> for dinner.>' 贪心匹配
##r'<.*?>' 匹配结果为'<To serve man>'              非贪心匹配
```

## Modules
### random
```py
import random
random_f = random.random() #生成[0.0 ~ 1.0)的float随机数
random_int = random.randint(2, 89)#生成[2, 89]内的整数

t = [1,2,3,'a']
elem = random.choice(t)#从t中随机选择一元素

#还提供生成符合高斯、指数、伽马等连续分布的随机值
```
### math
```py
import math
res = math.hypot(3, 4)  #res = 5, 返回欧几里德范数,等同于sqrt(x*x + y*y), 
res = math.atan2(dy, dx)#res = atan(dy/dx), unit:radian, not degree

```

### numpy

- numpy.ndarray

   ```py
   import numpy as np
   res = np.arange(start, end, interval) #返回类型'np.ndarray', 元素之间间隔问interval  (default=1),数组范围[start, end)
   res = np.arange(1, 6, 2) # array([1, 3, 5])
   
   a = np.array(['a',1,3,4]) #
   isinstance(a,np.ndarray)  #true
   
   np_array = np.random.random(5) #返回类型'np.ndarray',包含5个位于[0,1)的元素
   
   res = np.copy(arg) #arg可为普通'list'或'np.ndarray'，返回类型'np.ndarray'
   ```

- matrix usage

  ```py
  A = np.array([
        [1.1, 0.5, 0., 0.],
        [2., 1.2, 0., 0.],
        [3., 0., 1.3, 0.5],
        [4., 0., 0., 1.4]
    ])
  A.T             #矩阵A的转置
  np.linalg.inv(A)#矩阵A的逆矩阵
  A.shape    #返回矩阵的行列数:行(np.array里面list的个数), 列(list的长度)
  A.shape[0] #行数 4, np.array里面list的个数
  A.shape[1] #列数4, np.array里面list中元素的个数,不同的list元素个数不一样时将报错
  
  np.zeros((3,5))#3*5的零矩阵,即np.array里面list个数为3,每个list有全部为0的5个元素
  np.ones((3,5)) #3*5的矩阵,元素值都为1
  np.eye(4)      #结果如下,4*4的单位矩阵
  """
  array([[1., 0., 0., 0.],
       [0., 1., 0., 0.],
       [0., 0., 1., 0.],
       [0., 0., 0., 1.]])
  """

  a = np.array([0.8, 0.1, 0.1]).reshape((-1, 1))#结果如下
  """
  array([[0.8],
       [0.1],
       [0.1]])
  """
  ```