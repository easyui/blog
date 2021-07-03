# IOS中使用的C语言unlink函数

## 功能：删除一个名字（某些情况下删除这个名字所指向的文件）

## 头文件：#include<unistd.h>

## 函数原型： int unlink(const char* pathname);

## 功能详解：

unlink从文件系统中中删除一个名字，若这个名字是指向这个文件的最后一个链接，并且没有进程处于打开这个文件的状态，则删除这个文件，释放这个文件占用的空间。

如果这个名字是指向这个文件的最后一个链接，但有某个进程处于打开这个文件的状态，则暂时不删除这个文件，要等到打开这个文件的进程关闭这个文件的文件描述符后才删除这个文件。

如果这个名字指向一个符号链接，则删除这个符号链接。

如果这个名字指向一个socket、fifo或者一个设备，则这个socket、fifo、设备的名字被删除，当时打开这些socke、fifo、设备的进程仍然可以使用它们。

## 返回值：调用成功返回0，不成功返回-1.

## 代码示例：
```
pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/Movie%lu.mov",(unsigned long)urlArray.count]];
unlink([pathToMovie UTF8String]);
```



