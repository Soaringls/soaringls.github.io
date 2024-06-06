
[![note][travis-img]][travis-link]
[Markdown Reference](https://commonmark.org/help/)
<font color=#ff0000>md文档转为pdf时`enter`的换行符不识别，需用`<br>`换行</font>
## 文档格式 
`标题`
### 多级标题
#### asdf
##### asdf
**`-`和`*`的格式作用一致,`-`对字体不能设置斜体加粗**
you ***must*** run `./apollo.sh build_gpu`,and Note that bootstrap.sh the **bootstrap.sh** will *倾斜* **加粗** succeed， <kbd>OpenFolder</kbd>!
~~delete line~~
<u>下划线</u>
**<u>apollo</u>**

`分隔符`
***
asfasfasf
asfasfasf

asfasfasf
asfasf`af`s
```
https://github.com/ApolloAuto/apollo-kernel/releases
```
`https://github.com/ApolloAuto/apollo-kernel/releases`
`asasfd asfd asfd asdf asf`

    ##和前面内容隔一行，空4格开始，和```content```效果一致
    aa
    bb
    cc
```
asdfsafdasf
asfdasfasfasfaf
```
1. title
    ```
    asdfsafdasf
    asfdasfasfasfaf
    ```
- title 
    ```
    asdfsafdasf
    asfdasfasfasfaf
    ```
---
### 层级标题
`层级标题`
- 111
  - 111
    - 1112
  - 222
- 222
- 333
---
1. asd
2. asf
3. asf
   1. 111
   2. 222
4. asf
---
* asdf
* asfd
  * asfd
    * asfd
  * asdf


- [ ] asdfasf
- [x] asf

### 折叠内容
<details>
<summary>Ubuntu 14.04</summary>

#### Install these packages:

```bash
sudo apt install libopencv-dev libqglviewer-dev freeglut3-dev libqt4-dev
```
</details>
### 表格
**table 1**
| **Header**             | **Descr*ip*tion**                                    |
| ---------------------- | ---------------------------------------------------- |
| A                      | a                                                    |
| B                      | **b**:this is a new world                            |
| ![info](imgs/info.png) | **Info**  Contains information that might be useful. |
**table 2**
| **Header** | **Description**           |
| ---------- | ------------------------- |
| A          | a                         |
| B          | **b**:this is a new world |
### Math Formula
[markdown最全数学公式速查](https://blog.csdn.net/jyfu2_12/article/details/79207643)
[Mathematcis meta](https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference)

#### formula
$$
\tan(\delta) = \frac{L}{R} \tag1
$$

$$
\frac{l_d}{\sin(2\alpha)} = \frac{R}{\sin(\frac{\pi}{2} - \alpha)}
$$

$$
\frac{l_d}{2\sin(\alpha)\cos(\alpha)} = \frac{R}{\cos(\alpha)}
$$

$$
\frac{l_d}{\sin(\alpha)} = 2R \tag2
$$

$$
\delta = arctan(\frac{2L\sin(\alpha)}{l_d}) \tag3
$$

$$
l_d = l_{min} + v \cdot t_{ahead}
$$
$$
\dot e = v \cdot \sin(\psi - \delta) \tag4
$$
---
$\sum_{i=0}^N\int_{a}^{b}g(t,i)\text{d}t$
$\Gamma$
$C_n^2$
$\vec a = \vec b + $
$\int_a^{-b}g()\text{dt}exp\{a/b\}$
$\frac{a}{b}$  
$$
\approx
\times
\times
\equiv
$$
### href_link
`链接` 

[baidu_page_link](https://www.baidu.com)
跳转到标题`文档格式`可以点击[here](#文档格式)

you can click the `words` [百度][baidu3333_hide] by using search engine for more detail messages

---
### picture
`图片` ![picture](imgs/info.png)info contains information about...
<img src="imgs/top.png" width="100pix" height="156pix" /> <img src="imgs/birds.png" height="156pix" /> 

## Coding
```bash
#you can fixed the problems by this command
bash ./bootstrap.sh
```
```cpp

#include "modules/prediction/evaluator/evaluator.h"

namespace apollo {
class UbloxParser : public Parser {
public:
    UbloxParser();
    virtual MessageType get_message(MessagePtr& message_ptr);
private:
    bool verify_checksum();
    size_t _total_length = 0;

    ::apollo::drivers::gnss::Gnss _gnss;
}; 
}  // namespace apollo
```

//[baidu]前面空一行，后面再有`:`即可把该内容隐藏掉

[baidu1111]:https://catkin-tools.readthedocs.io/en/latest/installing.html

[baidu2222_hide]https://www.baidu.com

[baidu3333]:https://catkin-tools.readthedocs.io/en/latest/installing.html

[baidu3333_hide]:https://www.baidu.com

![info](imgs/info.png)

[travis-img]: https://img.shields.io/travis/PRBonn/depth_clustering/master.svg?style=for-the-badge
[travis-link]: https://travis-ci.org/PRBonn/depth_clustering

please contact upc_ls@163.com