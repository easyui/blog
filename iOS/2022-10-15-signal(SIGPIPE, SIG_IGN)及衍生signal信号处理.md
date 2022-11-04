# signal(SIGPIPE, SIG_IGN)只signal信号处理.md


## 结论

`signal(SIGPIPE, SIG_IGN)`的作用就是防止程序收到SIGPIPE后自动退出。

SIGPIPE:当一个程序a调用send函数向一个服务A发送信号的数据，服务A在接收数据的时候突然挂掉、无法接收数据、没有接收者，那么内核就会发送一个SIGPIPE信号，从而中断进程，导致程序退出。

SIG_IGN:忽略信号

## 使用

在程序启动添加 `signal(SIGPIPE, SIG_IGN)`

## signal信号处理

[[iOS]使用signal让app能够在从容崩溃](https://blog.csdn.net/weixin_30847939/article/details/95544405)


