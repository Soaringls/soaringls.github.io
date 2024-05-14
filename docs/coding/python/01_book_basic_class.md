# Python 类和对象
## chapter 15 类和对象
### 实例

```py
    class Point:
        """Represent a point in 2D space.
        attributes. x, y.
        """
        current_pt = 0 #类的变量, 相当于cpp的static成员变量
        """特殊方法"""
        """通常__init__方法的参数和属性名称一样"""
        def __init__(self, x = 0, y = 0):
            #类实例的变量
            self.x = x
            self.y = y

    class Rectangle:
        """Represents a rectangle.

        attributes: width, height, corner(Point's object:x,y).
        """

        """特殊方法"""
        """通常__init__方法的参数和属性名称一样"""
        def __init__(self, width = 0, height = 0, corner = Point()):
            #类实例的变量
            self.width = width
            self.height = height
            self.corner = corner

```

### Features
- 对象是可变的
>可以通过给一个对象的属性赋值来改变这个对象的状态
- 对象赋值
>别名会降低程序的可读性，因为一个地方的变动可能对另一个地方造成预料之外的影响
  ```py
  import copy #可以复制任何对象(仅仅局限于类的属性都为内置类型)
  p1 = Point()
  p.x = 3.0
  p.y = 4.0
  #copy
  p2 = copy.copy(p1)
  p1 is p2 #False 不是同一个对象
  p1 == p2 #False 变量标识符也不同
  isinstance(p1, Point) #内置函数判断自定义类型 True
  hasattr(p1, 'x') #内置函数判断对象p1是否有属性'x'
  vars(p1) #内置函数访问类对象的属性,返回字典 {'y': 4, 'x': 3}
  def print_attributes(obj):
      for attr in var(obj):
          print(attr, getattr(obj, attr)) #内置函数getattr根据对象和属性名称(字符串)返回属性的值
  try:
      x = p1.x
  except AttributeError:
      x = 0

  box1 = Rectangle()
  box2 = copy.copy(box1)
  box1 is box2 #False
  box1.corner is box2.corner #True 浅复制,没有复制嵌套的Point对象
  
  #深复制
  #不仅可以复制一个对象，还可以复制这个对象所引用的对象， 甚至可以复制这个对象所引用的对象所引用的对象
  box3 = copy.deepcopy(box1) 
  box3.corner is box1.corner #False
  ```

## chapter 16 类和函数
### 类示例

```py
class Time:
    """Represents the time of day.

    attribute:hour, minute, second
    """
    current_time = 0 #类的变量, 相当于cpp的static成员变量
    """特殊方法"""
    """通常__init__方法的参数和属性名称一样"""
    def __init__(self, hour = 0, minute = 0, second = 0):
        #类实例的变量
        self.hour = hour
        self.minute = minute
        self.second = second
```

### 函数实例
```py

def print_time(time):
    print('%.2d:%.2d:%.2d' % (time.hour, time.minute, time.second))
def time_to_int(time):
    minutes = time.hour * 60 + time.minute
    seconds = minutes * 60 + time.second
    return seconds
def int_to_time(seconds):
    time = Time()
    minutes, time.second   = divmod(seconds, 60)
    time.hour, time.minute = divmod(minutes, 60)
    return time
def valid_time(time):
    if time.hour < 0 or time.minute < 0 or time.second < 0:
        return False
    elif: time.minute >= 60 or time.second >=60:
        return False
    else:
        return True
def add_time_v1(t1, t2):
    if not valid_time(t1) or not valid_time(t2):
        raise ValueError('invalid Time object in add_time') #raise触发异常,并提示失败信息
    seconds = time_to_int(t1) + time_to_int(t2)
    return int_to_time(seconds)
def add_time_v2(t1, t2):
    assert valid_time(t1) and valid_time(t2)
    seconds = time_to_int(t1) + time_to_int(t2)
    return int_to_time(seconds)
```

## chapter 17 类和方法
>`self`需要为方法定义时的第一个参数,方法被实例调用时可忽略第一个参数self

- 类方法: 类方法是与类相关联的方法, 它们不需要实例化就可以调用, 类方法的第一个参数是类本身, 通常用`@classmethod`装饰器来定义
```py
class Time:
    """Represents the time of day.
    attribute:hour, minute, second
    """
    current_time = 0 #类的变量, 相当于cpp的static成员变量
    
    """特殊方法"""
    """通常__init__方法的参数和属性名称一样"""
    def __init__(self, hour = 0, minute = 0, second = 0):
        #类实例的变量
        self.hour = hour
        self.minute = minute
        self.second = second
    
    """特殊方法:方便调试, 可直接使用内置print函数打印对象信息
    time1 = Time()
    print(time1) #同time1.print_time()作用一样
    """
    def __str__(self):
        return '%.2d:%.2d:%.2d' % (self.hour, self.minute, self.second)
    
    
    """重载运算符(operator overloading)
    重载'__add__':可直接使用'+'运算符,但'+'左侧必须为当前类对象
    """
    def __add__(self, other):
    """类型分发: type-based dispatch
    other类型可以为当前类对象,也可为普通数值
    """
        if isinstance(other, Time):
            return add_time(other)
        else:
            return increment(other)
    def __radd__(self, other):
    """支持'+'左侧为普通数值类型,右侧为当前类对象
    """
        return self.__add__(other)
    
    
    """自定义方法"""
    def add_time(self, other):
        seconds = self.time_to_int() + other.time_to_init()
        return init_to_time(seconds)
    def increment(self, seconds):
        seconds += self.time_to_int()
        return init_to_time(seconds)
    def time_to_int(self):
        minutes = self.hour * 60 + self.minute
        seconds = minutes * 60 + self.second
        return seconds
    def int_to_time(seconds):
        time = Time()
        minutes, time.second   = divmod(seconds, 60)
        time.hour, time.minute = divmod(minutes, 60)
        return time
    def print_time(self):
        print('%.2d:%.2d:%.2d' % (self.hour, self.minute, self.second))
    def is_after(self, other):
        return self.time_to_init() > other.time_to_init()

#obj of the class Time
start = Time()      #00:00:00
start = Time(9)     #09:00:00
start = Time(9,45)  #09:45:00
start = Time(9,45,1)#09:45:01 提供三个参数，它们会覆盖三个默认值
print(start) #内置方法print时, python调用time的str方法

duration_obj = Time(1, 35)
print(start + duration) #因为重载了'__add__',可直接使用'+'运算符,重载了'__str__',可直接使用内置函数'print'打印结果
duration_num = 123

#'+'左侧为类对象,右侧为普通数值
print(start + duration_num)#直接调用重载的'__add__'
#'+'右侧为类对象,左侧为普通数值
print(duration_num + start)#通过调用'__radd__'间接调用重载的'__add__'
```

- 多态函数:适用于多种类型的函数
>如内置函数`sum`对一个序列的元素求和, 只要序列中的元素支持加法即可
  ```py
  #对前面的Time对象(重载了'+'运算符),sum也可以用于该对象
  t1 = Time(7, 43)
  t2 = Time(7, 41)
  t3 = Time(7, 37)
  total = sum([t1, t2, t3]) #
  print(total)              #调用Time类的str方法
  ```

## chapter 18 类的继承(inhert)

卡牌:`playing cards`
一副牌:`deck of hands`
牌型:`poker hand`
#### Card
```py
class Card:
    """代表一张标准的扑克卡牌"""

    def __init__(self, suit = 0, rank = 2):
    """实例属性: self.suit  self.rank,关联到特定的类的实例"""
       self.suit = suit
       self.rank = rank
    
    """类属性:相当于cpp 的static成员变量, 访问通过类名"""
    suit_names = ['Clubs', 'Diamonds', 'Hearts', 'Spades']
    rank_names = [None, 'Ace', '2', '3', '4', '5', '6', '7',
              '8', '9', '10', 'Jack', 'Queen', 'King']
    
    """重载运算符(operator overloading)
    重载'__lt__',小于运算符
    """
    def __lt__(self, other):
        # #判断换色
        # if self.suit < other.suit: return True
        # if self.suit > other.suit: return False
        # #花色相同,判断等级
        # return self.rank < other.rank

        #使用tuple进行比较
        t1 = self.suit, self.rank
        t2 = other.suit, other.rank
        return t1 < t2
    


    def __str__(self):
        return '%s of %s' % (Card.rank_names[self.rank],
                             Card.suit_names[self.suit])

card1 = Card(2,11)
print(card1) #Jack of Hearts
```
#### Deck
```py
class Deck:
    def __init__(self):
        self.cards = []
        for suit in range(4):
            for rank in range(1, 14):
                card = Card(suit, rank)
                self.cards.append(card)
    def __str__(self):
        res = []
        for card in cards:
            res.append(str(card))#内建函数str调用类的内部特殊函数'__str__'
        return '\n'.join(res)
    """普通方法"""
    def pop_card(self):
        #移除最后一个
        return self.cards.pop()
    def add_card(self, card):
        self.cards.append(card)

```
#### 子类Hand,继承自Deck
有点类似javascript咯,对于父类的方法子类若不重写的话将全部继承,重写的话将覆盖父类同名方法
子类`Hand`继承了`Deck`的`__init__`,提供一个`Hand`的`__init__`方法后会覆盖从父类`Deck`继承来的同名方法

```py
class Hand(Deck):
    """Represents a hand of playing cards."""
    
    """覆盖Deck的__init__方法,创建Hand实例时将不再调用Deck的同名方法"""
    def __init__(self, label=''):
        self.cards = []
        self.label = label
    def move_cards(self, hand, num):
        #将当前实例的num个card转移到另一Hand实例'hand',然后返回None
        for i in range(num):
            hand.add_card(self.pop_card())
     
```
#### 数据封装
```py
class Markov:
    def __init__(self):
        self.suffix_map = {}
        self.prefix = ()
    def process_word(self, word, order = 2):
        if len(self.prefix) < order:
            self.prefix += (wrod,)
            return
        try:
            self.suffix_map[self.prefix].append(word)
        except KeyError:
            #if there is no entry for this prefix,make one
            self.suffix_map[self.prefix] = [word]
        self.prefix = shift(self.prefix, word)
```
#### 调试
```py
def find_defining_class(obj, method_name):
    for ty in type(obj).mro():
        if method_name in ty.__dict__:
            return ty

hand = Hand() 
find_defining_class(hand, 'move_cards')#<class '__main__.Hand'>
find_defining_class(hand, 'pop_card')  #<class '__main__.Deck'>
find_defining_class(hand, '__init__')  #<class '__main__.Hand'>
```