# lion-lua-antitheftchain

## 特点
lua实现的防盗链机制，需部署在nginx上。性能优良。用于生产环境。

## 说明

### 代码文件
antitheftchain.lua 防盗链lua脚本  
nginx.conf 防盗链nginx配置  

### 实现概述
1、采用lua-nginx-module  
2、配置某个规则进入，通过set_by_lua，返回nginx变量。  
3、通过此变量true false，判断是否需要采用nginx rewrite  
4、另外需要防止rewrite资源被直接访问  

### 示例说明
如，对外的下载地址是：http://aaa.joy.cn/wap/加密串/bbb/ccc.mp4  
a、首先对wap进行统一处理，即/wap，其中判断加密串是否有效，有效则rewrite到 /realwap/bbb/ccc.mp4  
b、对realwap设置为虚拟目录，定位到外部目录，并且设置为只允许内部重定向访问，禁止客户端直接访问。  

### 防盗链算法
1、  
//路径MD5混淆策略1 0:不使用 1:每小时 2:每天 3:每月  
//路径MD5混淆策略2 0:不加入文件名混淆 1:加入文件名混淆  
每小时：md5(yyyyMMddHH+文件名+混淆码)  
每天：md5(yyyyMMdd+文件名+混淆码)  
每月：md5(yyyyMM+文件名+混淆码)  
2、服务端验证为了防止服务器之间时间不同步问题，因此需要做前后时间判断  
