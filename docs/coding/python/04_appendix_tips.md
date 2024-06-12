
# Appendix: tips

## 全局变量`global`
>函数外申明的都为全局变量，申明之后的地方才能使用，函数内同名变量将替换函数外的全局变量，函数内修改全局变量需用global关键字
  ```py
  var1 = 1 #函数外全局变量
  
  def func1():
    var1 = 2 #函数内局部变量，不会修改函数外的同名变量
  
  def func2():
    global var1
    var1 = 2 #修改函数外的var1
  ```

**global全局变量只能申明后再赋值，不支持申明时赋值**

```py
#正确用法
global text
text = "hello world"
#错误用法-->编译报错
global text = "hello world"
```

## 局部变量
>函数内的都是局部变量，for内定义的临时变量在for外也是可用的，但出了函数就不可用
  ```py
  def func():
    local_var = 1
    for i range(5):
      tmp_var = 2 #作用域不仅是for内，for外后面也可以，和C++的重大区别！！！！
    
    #local_var和tmp_var都为当前函数`func`内局部变量，申明后都可用
    sum_var = local_var + tmp_var 
  ```

## 列表list的clear和`=[]`
  ```py
  list1 = [1,2,3]
  list2 = [4,5,6]
  data = []
  data.append(list1) 
  data.append(list2) 
  
  list1.clear() #将会导致共同引用的data内的数据也清空
  list2 = []    #创建了一个新的空列表对象并将list2引用新的对象
  ```

## matplotlib note

### 坐标轴尺度问题

```py
import matplotlib.pyplot as plt
...
...
#坐标轴尺度统一，比如单位都为m
plt.axis("equal")  

#坐标轴尺度不一致，比如x轴单位为index或时间戳，y轴单位为m ---> 则不能使用 plt.axis("equal")
```
