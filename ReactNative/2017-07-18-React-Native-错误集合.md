# React Native Tips


## :smile:8081端口占用
```
ERROR Packager can't listen on port 8081
```
fix：

在终端如下操作：
1.lsof -n -i4TCP:8081 列出被占用的端口列表
2.kill -9 <PID> 找到与之对应的PID然后删除即可
3.重启服务npm start


