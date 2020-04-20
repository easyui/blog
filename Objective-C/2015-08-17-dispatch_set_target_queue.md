# dispatch_set_target_queue 

## dispatch_set_target_queue的两个作用：

### 1、用来给新建的queue设置优先级：
```
dispatch_queue_t serialQueue = dispatch_queue_create("com.oukavip.www",NULL);  
dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0);  
   
dispatch_set_target_queue(serialQueue, globalQueue);  
/* * 第一个参数为要设置优先级的queue,第二个参数是参照物，既将第一个queue的优先级和第二个queue的优先级设置一样。 
     */  
```     

需要注意的是，第一个参数是自定义的queue(默认优先级就是global queue的default)，而不是系统的queue（global/main）。因为你不能给系统的queue设置权限。通过上面设置，serialQueue 就有了与globalQueue一样的优先级。其实这个函数不仅可以设置queue的优先级，还可以设置queue之间的层级结构。

### 2、修改用户队列的目标队列，使多个serial queue在目标queue上一次只有一个执行：
它会把需要执行的任务对象指定到不同的队列中去处理，这个任务对象可以是dispatch队列，也可以是dispatch源。而且这个过程可以是动态的，可以实现队列的动态调度管理等等。比如说有两个队列dispatchA和dispatchB，这时把dispatchA指派到dispatchB：
```
dispatch_set_target_queue(dispatchA, dispatchB);
```
那么dispatchA上还未运行的block会在dispatchB上运行。这时如果暂停dispatchA运行：
```
dispatch_suspend(dispatchA);
```
则只会暂停dispatchA上原来的block的执行，dispatchB的block则不受影响。而如果暂停dispatchB的运行，则会暂停dispatchA的运行。

demo：

一般都是把一个任务放到一个串行的queue中，如果这个任务被拆分了，被放置到多个串行的queue中，但实际还是需要这个任务同步执行，那么就会有问题，因为多个串行queue之间是并行的。这时使用dispatch_set_target_queue将多个串行的queue指定到了同一目标，那么着多个串行queue在目标queue上就是同步执行的，不再是并行执行。

```
+(void)testTargetQueue {  
    dispatch_queue_t targetQueue = dispatch_queue_create("test.target.queue", DISPATCH_QUEUE_SERIAL);  
      
      
      
    dispatch_queue_t queue1 = dispatch_queue_create("test.1", DISPATCH_QUEUE_SERIAL);  
    dispatch_queue_t queue2 = dispatch_queue_create("test.2", DISPATCH_QUEUE_SERIAL);  
    dispatch_queue_t queue3 = dispatch_queue_create("test.3", DISPATCH_QUEUE_SERIAL);  
      
    dispatch_set_target_queue(queue1, targetQueue);  
    dispatch_set_target_queue(queue2, targetQueue);  
    dispatch_set_target_queue(queue3, targetQueue);  
      
      
    dispatch_async(queue1, ^{  
        NSLog(@"1 in");  
        [NSThread sleepForTimeInterval:3.f];  
        NSLog(@"1 out");  
    });  
  
    dispatch_async(queue2, ^{  
        NSLog(@"2 in");  
        [NSThread sleepForTimeInterval:2.f];  
        NSLog(@"2 out");  
    });  
    dispatch_async(queue3, ^{  
        NSLog(@"3 in");  
        [NSThread sleepForTimeInterval:1.f];  
        NSLog(@"3 out");  
    });  
      
      
      
}  
  
输出  
 1 in  
 1 out  
 2 in  
 2 out  
 3 in  
 3 out 
 ```