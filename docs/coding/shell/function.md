# Bash Shell Tips

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
