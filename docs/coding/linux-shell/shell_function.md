# Bash Shell Tips


## 基础语句
### if语句
| index | param     | desc                      |
| :---- | :-------- | :------------------------ |
| 1     | -d target | 存在且是一个目录则为true  |
| 2     | -f target | 存在且是一个普通文件-true |
| 3     | -L target | 存在且是一个符号链接-true |

 
```bash
if [ -z $base ] || [ -z $diff ] || [ -z $params ];then #-z表示base、diff、params中任意一个的长度为0则为真
    echo "need to input base, diff and params"
    exit 1
fi
```

### local变量
>shell中定义的变量以及函数内定义的变量是global的,作用于分别从被定义的地方开始/函数被调用时执行变量定义的地方开始...,一直到shell结束或者被显示删除处为止

**函数定义的变量可被显示的定义为local的,其作用域将局限于函数内，同时函数的参数也是local的，同名的local变量会屏蔽函数之外的global变量**

### 执行结果`$?`

>获取上一条命令的退出状态，即上一条命令执行后返回结果
  一般情况下，大部分命令执行成功后会返回0，失败返回1



### echo与eval
  ```bash
  history 10 > test  #导出终端最近的10条记录到当前目录的test文件中
  history 10 >> test  #导出终端最近的10条追加到当前目录的test文件中
  "$@"  #所有参数，使用时一般加双引号
  "$*"  #所有参数，作为一个字符串输出所有参数
  ###**********************
  ###eval
  ###显示执行eval后面第一个命令的执行结果,不能获得函数处理的结果,linux中eval嵌套无意义
  ###----------------------
  #1.执行带有字符串的命令
  eval "cat file1" -n      #执行cat命令,输出file1的内容,并带有行号,同"eval"
  echo "cat file1"         #输出"cat file1"
  eval echo "cat file1" -n #输出"cat file1 -n"
  #2.获取当前脚本收到的参数中最后一个参数
  echo "\$$#"      #输出当前脚本执行时收到的参数的个数
  eval echo "\$$#" #输出当前脚本执行时收到的参数中最后一个参数
  ```

## Array


```sh
function str2array() {
  local str=$1
  local delimiter=$2
  local array=(${str//${delimiter}/ })
  echo ${array[*]}
  return $?
}

### example usage
TOP_DIR="/a/b/c/d" #TOP_DIR="/a/b/c/d/" 也一样
path_arr=($(str2array ${TOP_DIR} "/")) #index:0,1,2,3,...
### output all element of array
echo "xxx all elements of array:${path_arr[*]} size:${#path_arr[*]}"
echo "xxx all elements of array:${path_arr[@]} size:${#path_arr[@]}"
### access last element of array
last_index=$((${#path_arr[@]}-1))
echo "xxx first elements of array:${path_arr[0]}"
echo "xxx last  elements of array:${path_arr[last_index]}"
 
```


## Function
>函数调用

```sh
# define function
###get last element of array
function get_last_element_of_array(){ 
    local array=($1)
    array=${array[*]} 
    local last_index=$((${#array[*]}-1)) 
    local last_elem=${array[last_index]}
    echo "${last_elem}" 
    return $?
} 

# call function
## example1: cmd invoke
(get_last_element_of_array "${path_arr[*]}")

## example2: invoke by variable
last_element="$(get_last_element_of_array "${path_arr[*]}")"
```
