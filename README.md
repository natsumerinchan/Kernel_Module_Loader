# Kernel Module Loader
 利用Magisk/KernelSU在开机后加载内核模块

## 使用方法

### 1、克隆本仓库
```
git clone https://github.com/natsumerinchan/Kernel_Module_Loader.git
```

### 2、将内核模块(.ko)放入kernel_module目录

### 3、修改customize.sh

- `MODULES_ARCH` 此项可限制模块的cpu架构

- 限定内核版本
```
# Check Kernel Version
kernel_version=$(uname -r | awk -F '-' '{print $1}')
case "$kernel_version" in
5.4.*) supported=true ;;
4.19.*) supported=true ;;
*) supported=false ;;
esac
```

- 要求内核开启某些配置
```
config_list="
    CONFIG_MODULES
    CONFIG_KPROBES
    CONFIG_HAVE_KPROBES
    CONFIG_KPROBE_EVENTS
"
```

### 4、修改module.prop
这个无需多讲，爱怎么改就怎么改

### 5、制作模块
```
zip -r MODULE_NAME.zip * -x .git ./kernel_module/.placeholder .gitattributes .gitgnore
```
